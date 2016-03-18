module Reality
  module Wikidata
    module Query
      PREFIX = %Q{
        PREFIX wikibase: <http://wikiba.se/ontology#>
        PREFIX wd: <http://www.wikidata.org/entity/> 
        PREFIX wdt: <http://www.wikidata.org/prop/direct/>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX p: <http://www.wikidata.org/prop/>
        PREFIX v: <http://www.wikidata.org/prop/statement/>
        PREFIX schema: <http://schema.org/>
      }

      # selecting
      #  ?entity wdt:* ?value
      #  ?entity rdfs:label ?label@en
      #  ?enwikiarticle schema:about ?entity
      PREDICATES = %Q{
        {
          ?s ?p ?o .
          FILTER(
            STRSTARTS(STR(?p), "http://www.wikidata.org/prop/direct/") ||
            (?p = rdfs:label && langMatches(lang(?o), "EN"))
          )
        } union {
          bind(schema:about as ?p) .
          ?o schema:about ?s .
          filter(strstarts(str(?o), "https://en.wikipedia.org/wiki/"))
        }
      }
      SERVICES = %Q{
        SERVICE wikibase:label {
          bd:serviceParam wikibase:language "en" .
        }
      }

      QUERY = %Q{
        #{PREFIX}
        
        SELECT ?s ?p ?o ?oLabel  WHERE {
          %{selectors} .
          #{PREDICATES} .
          #{SERVICES}
        }
      }

      SELECTORS = {
        wikipedia: '<https://en.wikipedia.org/wiki/%{title}> schema:about ?s',
        id: 'BIND(wd:%{id} as ?s)',
        label: '?s rdfs:label "%{label}"@en'
      }

      UNSAFE = Regexp.union(URI::UNSAFE, /[,()']/)

      using Refinements

      module_function

      def by_wikititle(*titles)
        fetch(:en_wikipage, titles.
          map{|t| SELECTORS[:wikipedia] % {title: URI.escape(t, UNSAFE)}}
        )
      end

      def by_id(*ids)
        fetch(:id, ids.map{|id| SELECTORS[:id] % {id: id}} )
      end

      def by_label(*labels)
        fetch(:label, labels.map{|l| SELECTORS[:label] % {label: l}} )
      end

      private

      module_function

      MAX_SLICE = 20

      def fetch(key, selectors)
        selectors.each_slice(MAX_SLICE).map{|chunk|
          fetch_sublist(selectors)
        }.flatten.map{|entity| [entity.send(key), entity]}.to_h
      end

      def fetch_sublist(selectors)
        make_query(selectors).
          derp{|query| faraday.get('', query: query, format: :json)}.
          derp{|res| Wikidata::Entity.from_sparql(res.body)}
      end

      def faraday
        @faraday ||= Faraday.new(url: 'https://query.wikidata.org/sparql'){|f|
          f.adapter Faraday.default_adapter
        }
      end

      def make_query(selectors)
        QUERY % {selectors: selectors.map{|sel| "{#{sel}}"}.join(" UNION ")}
      end
    end
  end
end
