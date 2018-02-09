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
        # I know about this methods' code quality, right? It is proof-of-concept

        inside = params.delete('inside')&.yield_self(&method(:coerce))
        type = params.delete('type')
        radius = (params.delete('radius') || 1000).to_f
        around = params.delete('around')&.yield_self(&method(:coerce))

        query = ''
        filter = ''

        if inside
          query << "#{inside}; map_to_area->.bounds;"
          filter << '(area.bounds)'
        end

        case around
        when Geo::Coord
          filter << "(around:#{radius},#{around.to_s(dms: false)})"
        when String
          query << "#{around}->.center;"
          filter << "(around.center:#{radius})"
        end

        filter << params.map { |k, v| '["%s"="%s"]' % [k, v] }.join

        # what exactly we select
        if type
          query << "#{type}#{filter};"
        else
          query << '(rel%s; way%s; node%s;);' % ([filter] * 3)
        end

        # what we output.
        # TODO: out counts, for "continue"?.. Though, we CAN'T continue as it has no pagination...
        # "asc" is "sort by id", typically it is "best guess" order (e.g. city Chiang Mai has lower
        # id than restaurant Chiang Mai and so on)
        query << 'out tags asc 10;'

        overpass_query(query).fetch('elements')
          .map { |el|
            Link.new(
              'osm',
              "#{SHORT_TYPE.fetch(el['type'])}(#{el['id']})",
              title: (el['tags'] || {}).values_at('name:en', 'name', 'int_name').compact.first
            )
          }
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

      def coerce(object)
        # FIXME: Very temp & naive, no validations
        case object
        when Entity
          if object.uri.start_with?('osm:')
            object.uri.sub(/^osm:/, '')
          else
            object['coordinates'] || object['coordinate location']
          end
        when Link
          if object.source == 'osm'
            object.id
          else
            entity = object.load
            entity['coordinates'] || entity['coordinate location']
          end
        when String, Geo::Coord
          object
        else
          fail ArgumentError, "Can't coerce to OpenStreetMap object: #{object.inspect}"
        end
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

Reality.describers['openstreetmap'] = Reality.describers['osm'] = Reality::Describers::OpenStreetMap.new
