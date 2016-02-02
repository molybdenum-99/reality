module Reality
  module Wikidata
    class Link
      attr_reader :id, :label

      def initialize(id, label = nil)
        @id, @label = id, label
      end
    end
    
    class Entity
      class << self
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
            group_by(&:first).map{|p, gs| [p, gs.map(&:last)]}.
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
            if hash['value'] =~ /^\s*point\s*\(\s*([\d.]+)\s+([\d.]+)\s*\)\s*$/i
              lat, lng = $1, $2
              Geo::Coord.new(lat.to_f, lng.to_f)
            else
              fail ArgumentError, "Unparseable WKT: #{hash['value']}"
            end
          else
            hash['value']
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
    end
  end
end
