require 'faraday'
require 'json'

module Reality
  module Describers
    class OpenStreetMap < Abstract::Base
      QUERY_REL = %{
        [out:json];
        rel(%{osm_id});
        out tags;
      }.freeze

      QUERY_NODE = %{
        [out:json];
        node(%{osm_id});
        out;
      }.freeze

      def observations_for(full_id)
        type, id = full_id.split(':')
        # FIXME: really temp!
        q = type == 'rel' ? QUERY_REL % {osm_id: id} : QUERY_NODE % {osm_id: id}
        query(q).fetch('elements').first
          .yield_self(&method(:parse_element))
          .map { |name, val| obs(full_id, name, val) }
      end

      private

      def prefix
        'osm'
      end

      def parse_element(el)
        {
          'meta.id' => el.values_at('type', 'id').join(':'),
          'meta.coord' => el.values_at('lat', 'lon').compact.yield_self
            .reject(&:empty?).first&.yield_self { |(lat, lng)| Geo::Coord.new(lat, lng) }
        }
          .merge(el.fetch('tags'))
          .map { |k, v| post_process(k, v) }
          .reject { |k, _| k.match(/:([a-z]{2,3})([-_][-_a-z]+)?$/) && Regexp.last_match[1] != 'en' }
          .to_h
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

      def query(text)
        faraday.post('', data: text).body.yield_self(&JSON.method(:parse))
        # TODO: It returns HTML error on wrong queries
      end
    end
  end
end
