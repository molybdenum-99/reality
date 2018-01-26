module Reality
  module Describers
    class Wikidata
      # TODO: cache, aliases
      class Units
        def initialize(&fetcher)
          @fetcher = fetcher
          @cache = {}
        end

        def get(url)
          return 'item' if url == '1'  # TODO: Measure[nil].new(1) #=> 1
          id = url.scan(%r{entity/(Q.+)}).flatten.first or fail("Unparseable unit #{url}")
          @cache.fetch(id).gsub(/[^a-z0-9]/i, '_')
        end

        def update_from(entity)
          ids = entity['claims']
            .values.flatten.map { |c| c.dig('mainsnak', 'datavalue', 'value', 'unit') rescue nil }
            .compact.uniq.grep_v('1')
            .map { |u| u.scan(%r{entity/(Q.+)}).flatten.first or fail("Unparseable unit #{u}") }
            .yield_self { |new_ids| new_ids - @cache.keys }

          return if ids.empty?
          @fetcher.call(*ids).yield_self(&@cache.method(:update))
        end
      end
    end
  end
end
