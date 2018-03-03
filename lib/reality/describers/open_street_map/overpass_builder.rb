module Reality
  module Describers
    class OpenStreetMap
      class OverpassBuilder
        attr_reader :params

        def initialize(params = {})
          @params = params
          @type = params.delete(:type)
          @limit = params.delete(:limit) || 10
        end

        class << self
          extend Memoist

          memoize def renderers
            {}
          end

          def param(name, &render)
            renderers[name] = render
          end

          def index_of(param)
            renderers.keys.index(param)
          end
        end

        # Attention! Order of parameters definition is important, it is exact order in which
        # they should be rendered!

        param :inside do |query, filter, object|
          query << "#{object}; map_to_area->.bounds;"
          filter << '(area.bounds)'
        end

        param :around do |query, filter, object|
          radius = params.fetch(:radius, 1000)

          case object
          when Geo::Coord
            filter << "(around:#{radius},#{object.to_s(dms: false)})"
          when String
            query << "#{object}->.center;"
            filter << "(around.center:#{radius})"
          end
        end

        param :tags do |query, filter, list|
          filter << list.map { |k, v| '["%s"="%s"]' % [k, v] }.join
        end

        def to_s
          query = ''
          filter = ''

          @params
            .select { |name, _| self.class.index_of(name) }
            .sort_by { |name, _| self.class.index_of(name) }
            .each { |name, value|
              instance_exec(query, filter, value, &self.class.renderers[name])
            }

          query <<
            if @type
              "#{@type}#{filter};"
            else
              '(rel%s; way%s; node%s;);' % ([filter] * 3)
            end

          # what we output.
          # "asc" is "sort by id", typically it is "best guess" order (e.g. city Chiang Mai has lower
          # id than restaurant Chiang Mai and so on)
          # TODO: out counts, for "continue"?.. Though, we CAN'T continue as it has no pagination...
          query << "out tags asc #{@limit};"

          query
        end
      end
    end
  end
end
