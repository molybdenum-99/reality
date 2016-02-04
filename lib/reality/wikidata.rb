module Reality
  using Reality::Refinements
  
  module Wikidata
    class Link
      attr_reader :id, :label

      def initialize(id, label = nil)
        @id, @label = id, label
      end

      def inspect
        "#<#{self.class}(#{[id, label].compact.join(': ')})>"
      end

      def to_s
        label || id
      end
    end
    
    class Entity
      QUERY = %Q{
        PREFIX wikibase: <http://wikiba.se/ontology#>
        PREFIX wd: <http://www.wikidata.org/entity/> 
        PREFIX wdt: <http://www.wikidata.org/prop/direct/>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX p: <http://www.wikidata.org/prop/>
        PREFIX v: <http://www.wikidata.org/prop/statement/>

        SELECT ?id ?p ?o ?oLabel  WHERE {
          ?id rdfs:label "%s"@en .
          {
            ?id ?p ?o .
            FILTER(STRSTARTS(STR(?p), "http://www.wikidata.org/prop/direct/"))
          } union {
            ?id ?p ?o .
            filter(langMatches(lang(?o), "EN")).
            filter(?p = rdfs:label)
          }
          SERVICE wikibase:label {
            bd:serviceParam wikibase:language "en" .
          }
         }
      }
      class << self
        def faraday
          @faraday ||= Faraday.new(url: 'https://query.wikidata.org/sparql'){|f|
            f.adapter Faraday.default_adapter
          }
        end
        
        def fetch(title)
          faraday.get('', query: QUERY % title, format: :json).
            derp{|res| from_sparql(res.body, subject: 'id', predicate: 'p', object: 'o', object_label: 'oLabel')}
        end
        
        def from_sparql(sparql_json, subject: 'subject', predicate: 'predicate', object: 'object', object_label: 'object_label')
          JSON.parse(sparql_json)['results']['bindings'].map{|row|
            [
              row[subject]['value'].sub('http://www.wikidata.org/entity/', ''),
              row[predicate]['value'].sub('http://www.wikidata.org/prop/direct/', ''),
              row[object].merge('label' => row[object_label]['value'])
            ]
          }.group_by(&:first).
          map{|id, rows|
            new(id, hash_from_predicates(rows))
          }
        end

        def hash_from_predicates(rows)
          rows.map{|s, p, o| [p, parse_value(o)]}.
            group_by(&:first).map{|p, gs| [p, gs.map(&:last).compact]}.
            to_h
        end

        def parse_value(hash)
          case hash['type']
          when 'literal'
            parse_literal(hash)
          when 'uri'
            parse_uri(hash)
          else
            fail ArgumentError, "Unidentifieble datatype: #{hash['type']}"
          end
        end

        def parse_uri(hash)
          if hash['value'] =~ %r{https?://www\.wikidata\.org/entity/([^/]+)$}
            Link.new($1, hash['label'])
          else
            hash['value']
          end
        end

        def parse_literal(hash)
          case hash['datatype']
          when 'http://www.w3.org/2001/XMLSchema#decimal'
            hash['value'].to_i
          when 'http://www.opengis.net/ont/geosparql#wktLiteral'
            # TODO: WTF
            if hash['value'] =~ /^\s*point\s*\(\s*([-\d.]+)\s+([-\d.]+)\s*\)\s*$/i
              lat, lng = $1, $2
              Geo::Coord.new(lat.to_f, lng.to_f)
            else
              fail ArgumentError, "Unparseable WKT: #{hash['value']}"
            end
          else
            if hash['xml:lang'] && hash['xml:lang'] != 'en'
              nil
            else
              hash['value']
            end
          end
        end
      end

      attr_reader :id

      def initialize(id, predicates)
        @id, @predicates = id, predicates
      end

      def [](pred)
        @predicates[pred]
      end

      def label
        self['http://www.w3.org/2000/01/rdf-schema#label'].first
      end

      def inspect
        "#<#{self.class}(#{[id, label].compact.join(': ')})>"
      end

      def to_s
        label || id
      end

      def to_h
        @predicates
      end
    end
  end
end
