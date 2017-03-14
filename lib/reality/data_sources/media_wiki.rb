module Reality
  using Refinements
  
  module DataSources
    class MediaWiki
      attr_reader :parsers
    
      def initialize(symbol, api_url, *parsers)
        @symbol = symbol
        @internal = Infoboxer::MediaWiki.new(api_url)
        @parsers = parsers
      end

      def on(path, name, coerce)
        parsers << {path: path, name: name, coerce: coerce}
      end

      def find(title)
        Entity.new(find_observations(title)) # FIXME: what if observations are found for several entities?
      end

      def find_observations(title)
        @internal.get(title).derp { |page|
          [
            Observation.new(:_source, Link.new(@symbol, title)),
            Observation.new(:title, page.title),
            *@parsers.map { |name:, path:, coerce:|
              path.call(page).derp { |v| v && coerce_value(v, coerce) }.derp { |v| v && Observation.new(name, v) }
            }
          ]
        }
      end

      private

      def as_string(value)
        value.text
      end

      def coerce_value(value, coercer)
        case coercer
        when Proc
          coercer.call(value)
        when Symbol
          send(coercer, value)
        when nil
          value
        else
          fail TypeError, "Undefined coercer #{coercer}"
        end
      end
    end
  end
end
