module Reality
  using Refinements
  
  module DataSources
    class MediaWiki
      attr_reader :parsers
    
      def initialize(symbol, api_url, *parsers)
        @symbol = symbol
        @parsers = parsers
        @api_url = api_url
      end

      def on(path, name, coerce, **args)
        parsers << {path: path, name: name, coerce: coerce, args: args}
      end

      def find(title)
        Entity.new(find_observations(title)) # FIXME: what if observations are found for several entities?
      end

      def find_observations(title)
        internal.get(title).derp { |page|
          [
            Observation.new(:_source, Link.new(@symbol, title)),
            Observation.new(:title, page.title),
            *@parsers.map { |name:, path:, coerce:, args:|
              path.call(page).derp { |v| v && coerce_value(v, coerce, **args) }.derp { |v| v && Observation.new(name, v) }
            }
          ]
        }
      end

      private

      def internal
        @internal ||= Infoboxer::MediaWiki.new(@api_url)
      end

      def as_string(nodes, **)
        nodes.text
      end

      # FIXME: In fact, en.wikipedia.org-specific!
      def as_coord_from_array(template, **)
        values = template.unnamed_variables.map(&:children).map(&:text).grep_v(/^(\w+):/)
        case values.count
        when 2 # {{Coord|40|50}}
          Geo::Coord.new(latd: values[0].to_f, lngd: values[1].to_f)
        when 4 # {{Coord|40|N|50|W}}
          Geo::Coord.new(latd: values[0].to_f, lath: values[1], lngd: values[2].to_f, lngh: values[3])
        when 6 # {{Coord|40|20|N|50|10|W}}
          Geo::Coord.new(
            latd: values[0].to_i,
            latm: values[1].to_i,
            lath: values[2],
            lngd: values[3].to_i,
            lngm: values[4].to_i,
            lngh: values[5]
          )
        when 8 # {{Coord|40|20|11|N|50|10|12|W}}
          Geo::Coord.new(
            latd: values[0].to_i,
            latm: values[1].to_i,
            lats: values[2].to_f,
            lath: values[3],
            lngd: values[4].to_i,
            lngm: values[5].to_i,
            lngs: values[6].to_f,
            lngh: values[7]
          )
        else
          fail ArgumentError, "Undefined template format #{template.inspect}"
        end
      end

      def as_link(nodes, **)
        nodes.lookup(:Wikilink).first.derp { |l| Link.new(@symbol, l.link) }
      end

      def as_measure(nodes, unit:)
        Measure[unit].new(Util::Parse.scaled_number(nodes.text))
      end

      def coerce_value(value, coercer, **args)
        case coercer
        when Proc
          coercer.call(value, **args)
        when Symbol
          send(coercer, value, **args)
        when nil
          value
        else
          fail TypeError, "Undefined coercer #{coercer}"
        end
      end
    end
  end
end
