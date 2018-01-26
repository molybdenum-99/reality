require 'infoboxer'

module Reality
  module Describers
    module Abstract
      class MediaWiki < Base
        REQUEST_PARAMS = []

        def observations_for(title)
          parse_page(internal.get(title, &method(:setup_request)))
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
