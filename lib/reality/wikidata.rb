require_relative 'wikidata/query'

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
      class << self
        def by_wikititle(*titles)
          Query.by_wikititle(*titles)
        end

        def by_id(*ids)
          Query.by_id(*ids)
        end

        def by_label(*labels)
          Query.by_label(*labels)
        end

        def one_by_wikititle(title)
          by_wikititle(title).values.first
        end

        def one_by_id(id)
          by_id(id).values.first
        end

        def one_by_label(label)
          by_label(label).values.first
        end

        def from_sparql(sparql_json)
          JSON.parse(sparql_json)['results']['bindings'].map{|row|
            [
              row['s']['value'].sub('http://www.wikidata.org/entity/', ''),
              row['p']['value'].sub('http://www.wikidata.org/prop/direct/', ''),
              row['o'].merge('label' => row['oLabel']['value'])
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

        # FIXME: move all parse_* to util/parsers or wikidata/parsers
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

      def id_i
        id.sub('Q', '').to_i
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
