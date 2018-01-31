module Reality
  module Describers
    class Wikidata
      class SparqlClient
        extend Memoist

        PREFIX = %{
          PREFIX wikibase: <http://wikiba.se/ontology#>
          PREFIX wd: <http://www.wikidata.org/entity/>
          PREFIX wdt: <http://www.wikidata.org/prop/direct/>
          PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
          PREFIX p: <http://www.wikidata.org/prop/>
          PREFIX v: <http://www.wikidata.org/prop/statement/>
          PREFIX schema: <http://schema.org/>
        }

        FIND_BY_PROPERTY = %{
          #{PREFIX}

          SELECT ?item ?itemLabel WHERE {
            ?item %{predicates}.
            SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
          }
          LIMIT 10
        }

        def initialize(log: nil)
          @log = log || Logger.new(nil)
        end

        def query(predicates)
          p predicates
          predicates_query = predicates.map { |name, datatype, value|
            '%<predicate>s %<value>s' % {predicate: name, value: recode_value(value, datatype)}
          }.join('; ')
          query = FIND_BY_PROPERTY % {predicates: predicates_query}
          log.debug "Wikidata SPARQL: #{query}"
          connection.get('', query: query, format: :json).body
            .yield_self(&JSON.method(:parse))
            .dig('results', 'bindings')
            .map { |bind|
              m = bind.dig('item', 'value').match(/(Q\d+)/) or next
              Link.new(
                'wikidata',
                m[1],
                title: bind.dig('itemLabel', 'value')
              )
            }.compact
        end

        private

        def recode_value(value, datatype)
          case datatype
          when 'monolingualtext'
            value.to_s.inspect + '@en'
          when 'quantity'
            value.to_f.inspect
          when 'wikibase-item'
            wd_value(value)
          when 'string'
            value.to_s.inspect
          else
            fail ArgumentError, "Can not transcode data type #{datatype.inspect}"
          end
        end

        def wd_value(value)
          id = case value
            when /^Q\d+/
              value
            when Link
              fail ArgumentError, "Non-wikidata link #{value}" unless value.source == 'wikidata'
              value.id
            else
              fail ArgumentError, "Can't coerce #{value.inspect} into link to wikidata"
            end
          "wd:#{id}"
        end

        attr_reader :log

        memoize def connection
          Faraday.new('https://query.wikidata.org/sparql')
        end
      end
    end
  end
end
