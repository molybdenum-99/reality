module Reality
  using Refinements
  
  module DataSources
    class MediaWiki
      def initialize(symbol, api_url, *parsers)
        @symbol = symbol
        @internal = Infoboxer::MediaWiki.new(api_url)
        @parsers = parsers
      end

      def get(title)
        @internal.get(title).derp { |page|
          [
            Observation.new(:_source, Link.new(@symbol, title)),
            Observation.new(:title, page.title),
            *@parsers.map { |name:, path:, coerce:|
              path.call(page).derp { |v| v && coerce.call(v) }.derp { |v| v && Observation.new(name, v) }
            }
          ]
        }
      end
    end
  end
end
