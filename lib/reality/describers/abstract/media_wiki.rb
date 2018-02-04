require 'infoboxer'

module Reality
  module Describers
    module Abstract
      class MediaWiki < Base
        REQUEST_PARAMS = []

        def observations_for(title)
          parse_page(internal.get(title, &method(:setup_request)))
        end

        def perform_query(params = {})
          if (c = params['category'])
            category = case c
            when Link
              # FIXME: in future, for other language wikis, we can't do this, they may have _local_
              # category names.
              c.source == prefix or fail ArgumentError, "Wrong source #{c.source}"
              c.id =~ /^category:(.+)$/i or fail ArgumentError, "Wrong Wikipedia page (not a category) #{c.id}"
              Regexp.last_match[1]
            when String
              c.sub(/^category:/i, '')
            else
              fail ArgumentError, "Not a link #{c.inspect}"
            end
            internal.api.query.list(:categorymembers).title('Category:' + category)
              .response['categorymembers']
              .map { |m| m.fetch('title') }
              .flatten
              .map { |title| Link.new(prefix, title) }
          elsif (s = params['search'])
            internal.api.query.list(:search).search(s)
              .response['search']
              .map { |m| m.fetch('title') }
              .flatten
              .map { |title| Link.new(prefix, title) }
          elsif (p = params['around'])
            point = case p
            when Array
              p.join('|')
            when Geo::Coord
              p.strfcoord('%lat|%lng')
            when Entity
              (p['coordinates'] || p['coordinate location'])&.value&.strfcoord('%lat|%lng')
            when /^\d+(?:\.\d+)?[,\| ;]\d+(?:\.\d+)?$/
              p.split(/[,\| ;]/).join('|')
            end

            radius = (params['radius'] || 500).to_i
            internal.api.query.list(:geosearch).coord(point).radius(radius)
              .response['geosearch']
              .map { |m| m.fetch('title') }
              .flatten
              .map { |title| Link.new(prefix, title) }
          end
        end

        private

        def setup_request(req)
          req
        end

        memoize def internal
          Infoboxer::MediaWiki.new(self.class::API_URL)
        end
      end
    end
  end
end
