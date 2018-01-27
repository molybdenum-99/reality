module Reality
  module Describers
    class Wikidata
      module Sparql
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

          SELECT ?item ?itemLabel ?val WHERE {
            ?item wdt:%<predicate> %<value>.
            SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
          }
          GROUP BY ?item
          LIMIT 100
        }

        def ids_by_predicate(pred, value)
        end
      end
    end
  end
end
