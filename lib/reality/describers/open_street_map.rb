require 'faraday'
require 'json'
require 'nokogiri'

module Reality
  module Describers
    class OpenStreetMap < Abstract::Base
      QueryError = Class.new(StandardError)

      def observations_for(id)
        overpass_query('%{id}; out;' % {id: id})
          .fetch('elements').first
          .yield_self(&method(:parse_element))
          .map { |name, val| obs(id, name, val) }
      end

      def perform_query(params)
        filters, tags = Hm(params).partition('type', 'inside', 'around', 'radius', 'limit')
        prepared = Hm(filters)
          .transform_keys(&:to_sym)
          .transform_values(:inside, :around, &Coerce.method(:osm_id))
          .transform_values(:radius, &:to_f)
          .to_h
          .merge(tags: tags)

        query = OverpassBuilder.new(prepared).to_s

        overpass_query(query).fetch('elements')
          .map(&method(:parse_link))
      end

      private

      def prefix
        'osm'
      end

      SHORT_TYPE = {
        'node' => 'node',
        'way' => 'way',
        'relation' => 'rel'
      }

      def parse_element(el)
        type, id = el.values_at('type', 'id')
        {
          'meta.id' => "#{SHORT_TYPE.fetch(type)}(#{id})",
          'meta.url' => "https://www.openstreetmap.org/#{type}/#{id}",
          'meta.coord' => el.values_at('lat', 'lon').compact.yield_self
            .reject(&:empty?).first&.yield_self { |(lat, lng)| Geo::Coord.new(lat, lng) }
        }
          .merge(el.fetch('tags', {}))
          .map { |k, v| post_process(k, v) }
          .reject { |k, _| k.match(/:([a-z]{2,3})([-_][-_a-z]+)?$/) && Regexp.last_match[1] != 'en' }
          .to_h
      end

      def parse_link(el)
        # FIXME: In fact, we fetch proper entities from Overpass, not just links
        Link.new(
          'osm',
          "#{SHORT_TYPE.fetch(el['type'])}(#{el['id']})",
          title: (el['tags'] || {}).values_at('name:en', 'name', 'int_name').compact.first
        )
      end

      def post_process(key, value)
        value = case key
        when 'population'
          Measure['person'].new(value.to_i)
        when 'sqkm'
          Measure['km²'].new(value.to_f)
        when /(^|:)wikidata$/
          Link.new('wikidata', value)
        when 'wikipedia'
          lang, title = value.split(':', 2)
          Link.new("wikipedia:#{lang}", title)
        else
          value
        end
        [key, value]
      end

      def faraday
        @faraday ||= Faraday.new('http://overpass-api.de/api/interpreter')
      end

      def overpass_query(text)
        text = "[out:json]; #{text}"

        log.debug "Running OverpassQL query: \n  #{text}"

        faraday.post('', data: text).tap(&method(:ensure_success))
          .body.yield_self(&JSON.method(:parse))
        # TODO: It returns HTML error on wrong queries
      end

      def ensure_success(response)
        return if (200...400).cover?(response.status)

        Nokogiri::HTML(response.body).search('p').to_a[1..-1].map(&:text).first
          .yield_self { |text| fail QueryError, text }
      end
    end
  end
end

require_relative 'open_street_map/overpass_builder'

Reality.describers['openstreetmap'] = Reality.describers['osm'] = Reality::Describers::OpenStreetMap.new
