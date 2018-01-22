module Reality
  using Refinements

  module DataSources
    class Worldbank
      def get(id)
        if id.include?(':')
          iso, indicator = id.split(':')
          internal.countries[iso].indicator(indicator)['data'].first(3)
        else
          internal.countries[id].get['data'].first.tap(&m(:post_process)).merge(indicators_for(id))
        end
      end

      private

      def internal
        @internal ||= API.new
      end

      def post_process(row)
        row['coord'] = Geo::Coord.new(row.delete('latitude'), row.delete('longitude'))
      end

      def indicators_for(iso)
        indicators.map { |i| "#<Link[#{iso}:#{i}]>" }
      end

      def indicators
        pp internal.dictionaries.indicators.list['data']['id']
        exit
        #@indicators ||=
      end
    end
  end
end

require_relative 'worldbank/api'
