module Reality
  using Refinements
  
  module DataSources
    class Wikidata
      def initialize(predicates = {})
        @predicates = predicates
      end
    
      def get(id)
        ::Wikidata::Item.find(id)
          .derp { |item|
            [
              Observation.new(:_source, Link.new(:wikidata, id)),
              *item
                .instance_variable_get('@hash').claims.flat_map { |id, claims| claims2observations(id, claims) }
                .compact
                .reject { |o| o.value.nil? }
            ]
          }
      end

      private

      def claims2observations(id, claims)
        claims.map { |c| Observation.new(convert_predicate(id), convert_value(c.dig('mainsnak', 'datavalue'))) }
      end

      def convert_predicate(id)
        @predicates.fetch(id.to_sym, "_#{id}".to_sym)
      end

      def convert_value(val)
        case val['type']
        when 'string'
          val['value']
        else
          #fail ArgumentError, "Unprocessabel type: #{val['type']}"
        end
      end
    end
  end
end
