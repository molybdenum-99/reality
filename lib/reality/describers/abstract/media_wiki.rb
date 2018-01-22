require 'infoboxer'

module Reality
  module Describers
    module Abstract
      class MediaWiki < Base
        REQUEST_PARAMS = []

        def observations_for(title)
          parse_page(internal.get(title, *self.class::REQUEST_PARAMS))
        end

        private

        memoize def internal
          Infoboxer::MediaWiki.new(self.class::API_URL)
        end
      end
    end
  end
end
