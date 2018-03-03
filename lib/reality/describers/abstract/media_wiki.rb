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
            category = Coerce.media_wiki_category(c, internal)
            fetch_list(:categorymembers) { |api| api.title(category) }
          elsif (s = params['search'])
            fetch_list(:search) { |api| api.search(s) }
          elsif (p = params['around'])
            point = Coerce.geo_coord(p).strfcoord('%lat|%lng')
            radius = params.fetch('radius', 500).to_i

            fetch_list(:geosearch) { |api| api.coord(point).radius(radius) }
          end
        end

        private

        def setup_request(req)
          req
        end

        def fetch_list(key, &setup)
          internal.api.query.list(key).yield_self(&setup)
            .response[key.to_s]
            .flat_map { |m| m.fetch('title') }
            .map { |title| Link.new(prefix, title) }
        end

        memoize def internal
          Infoboxer::MediaWiki.new(self.class::API_URL)
        end
      end
    end
  end
end
