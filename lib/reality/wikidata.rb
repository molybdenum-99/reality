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

    # FIXME: I should be burn in hell for this mess. But it works. Somehow.
    class Entity
      PREFIX = %Q{
        PREFIX wikibase: <http://wikiba.se/ontology#>
        PREFIX wd: <http://www.wikidata.org/entity/> 
        PREFIX wdt: <http://www.wikidata.org/prop/direct/>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX p: <http://www.wikidata.org/prop/>
        PREFIX v: <http://www.wikidata.org/prop/statement/>
        PREFIX schema: <http://schema.org/>
      }
      
      SINGLE_QUERY = %Q{
        #{PREFIX}
        
        SELECT ?id ?p ?o ?oLabel  WHERE {
          <https://en.wikipedia.org/wiki/%{title}> schema:about ?id .
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

      ID_QUERY = %Q{
        #{PREFIX}
        
        SELECT ?id ?p ?o ?oLabel  WHERE {
          bind(wd:%{id} as ?id)
          {
            ?id ?p ?o .
            FILTER(
              STRSTARTS(STR(?p), "http://www.wikidata.org/prop/direct/") ||
              (?p = rdfs:label && langMatches(lang(?o), "EN"))
            )
          } union {
            bind(schema:about as ?p) .
            ?o schema:about ?id .
            filter(strstarts(str(?o), "https://en.wikipedia.org/wiki/"))
          }
          SERVICE wikibase:label {
            bd:serviceParam wikibase:language "en" .
          }
         }
      }

      MULTIPLE_QUERY = %Q{
        #{PREFIX}

        SELECT ?id ?p ?o ?oLabel  WHERE {
          %{selectors} .
          {
            ?id ?p ?o .
            FILTER(
              STRSTARTS(STR(?p), "http://www.wikidata.org/prop/direct/") ||
              (?p = rdfs:label && langMatches(lang(?o), "EN"))
            )
          } union {
            bind(schema:about as ?p) .
            ?o schema:about ?id .
            filter(strstarts(str(?o), "https://en.wikipedia.org/wiki/"))
          }
          SERVICE wikibase:label {
            bd:serviceParam wikibase:language "en" .
          }
         }
      }
      MULTIPLE_IDS_QUERY = %Q{
        #{PREFIX}

        SELECT ?id ?p ?o ?oLabel  WHERE {
          %{selectors} .
          {
            ?id ?p ?o .
            FILTER(
              STRSTARTS(STR(?p), "http://www.wikidata.org/prop/direct/") ||
              (?p = rdfs:label && langMatches(lang(?o), "EN"))
            )
          } union {
            bind(schema:about as ?p) .
            ?o schema:about ?id .
            filter(strstarts(str(?o), "https://en.wikipedia.org/wiki/"))
          }
          SERVICE wikibase:label {
            bd:serviceParam wikibase:language "en" .
          }
         }
      }
      SELECTOR = %Q{
        {
          <https://en.wikipedia.org/wiki/%{title}> schema:about ?id
        }
      }
      IDSELECTOR = %Q{
        {
          BIND(wd:%{id} as ?id)
        }
      }

      UNSAFE = Regexp.union(URI::UNSAFE, /[,()']/)
      
      class << self
        def faraday
          @faraday ||= Faraday.new(url: 'https://query.wikidata.org/sparql'){|f|
            f.adapter Faraday.default_adapter
          }
        end

        def fetch(title)
          title = URI.escape(title, UNSAFE)
          faraday.get('', query: SINGLE_QUERY % {title: title}, format: :json).
            derp{|res| from_sparql(res.body, subject: 'id', predicate: 'p', object: 'o', object_label: 'oLabel')}
        end

        def fetch_by_id(id)
          faraday.get('', query: ID_QUERY % {id: id}, format: :json).
            derp{|res| from_sparql(res.body, subject: 'id', predicate: 'p', object: 'o', object_label: 'oLabel')}.
            first
        end

        WIKIURL = 'https://en.wikipedia.org/wiki/%{title}'

        MAX_SLICE = 20

        def fetch_list(*titles)
          titles.each_slice(MAX_SLICE).map{|titles_chunk|
            fetch_small_list(*titles_chunk)
          }.inject(:merge)
        end

        def fetch_list_by_id(*ids)
          ids.each_slice(MAX_SLICE).map{|ids_chunk|
            fetch_small_idlist(*ids_chunk)
          }.inject(:merge)
        end

        def fetch_small_list(*titles)
          titles.
            map{|t| SELECTOR % {title: URI.escape(t, UNSAFE)}}.
            join(' UNION ').
            derp{|selectors| MULTIPLE_QUERY % {selectors: selectors}}.
            derp{|query|
              faraday.get('', query: query, format: :json)
            }.
            derp{|res|
              from_sparql(
                res.body,
                subject: 'id',
                predicate: 'p',
                object: 'o',
                object_label: 'oLabel')
            }.
            map{|e|
              [e.en_wikipage, e]
            }.to_h
        end


        def fetch_small_idlist(*ids)
          ids.
            map{|i| IDSELECTOR % {id: i}}.
            join(' UNION ').
            derp{|selectors| MULTIPLE_IDS_QUERY % {selectors: selectors}}.
            derp{|query|
              faraday.get('', query: query, format: :json)
            }.
            derp{|res|
              from_sparql(
                res.body,
                subject: 'id',
                predicate: 'p',
                object: 'o',
                object_label: 'oLabel')
            }.
            map{|e|
              [e.id, e]
            }.to_h
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
          when 'bnode'
            nil
          else
            fail ArgumentError, "Unidentifieble datatype: #{hash['type']} in #{hash}"
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
          when 'http://www.w3.org/2001/XMLSchema#dateTime'
            DateTime.parse(hash['value'])
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

      attr_reader :id, :predicates

      def initialize(id, predicates)
        @id, @predicates = id, predicates
      end

      def [](pred)
        @predicates[pred]
      end

      def label
        self['http://www.w3.org/2000/01/rdf-schema#label'].first
      end

      def about
        self['http://schema.org/about']
      end

      def en_wikipage
        return nil unless about
        
        name = about.first.
          scan(%r{https://en\.wikipedia\.org/wiki/(.+)$}).
          flatten.first.derp{|s| URI.unescape(s)}
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
