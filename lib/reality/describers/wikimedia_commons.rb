module Reality
  module Describers
    class WikimediaCommons < Abstract::MediaWiki
      API_URL = Infoboxer.url_for(:commons)

      private

      def prefix
        'wikimedia-commons'
      end

      # FIXME: duplicates with Wikipedia

      def setup_request(request)
        request
          .prop(:pageimages).prop(:thumbnail, :original) # main image of the page
      end

      def parse_page(page)
        parse_meta(page).map { |params| obs(page.title, *params) }
      end

      def parse_meta(page)
        [
          ['meta.title', page.title],
          ['meta.url', page.url],
          ['meta.image', page.source.dig('original', 'source')],
          ['meta.thumb', page.source.dig('thumbnail', 'source')],
          *category_meta(page)
        ].select(&:last)
      end

      def category_meta(page)
        return [] unless page.category?
        [['meta.pages', Query.new(prefix, category: page.title)]]
      end
    end
  end
end

Reality.describers['wikimedia-commons'] = Reality::Describers::WikimediaCommons.new
