module Reality
  module Describers
    class Wikipedia < Abstract::MediaWiki
      include Infoboxer::Navigation::Helpers

      API_URL = Infoboxer.url_for(:wikipedia)

      private

      def prefix
        'wikipedia:en'
      end

      def setup_request(request)
        request
          .prop(:pageimages).prop(:thumbnail, :original) # main image of the page
          .prop(:wbentityusage).aspect('O') # links to wikidata, only "O" aspect (which means "Other", which somehow stands for "main entity")
      end

      def parse_page(page)
        (parse_meta(page) +
        parse_infoboxes(page))
          .map { |params| obs(page.title, *params) }
      end

      def parse_meta(page)
        [
          ['meta.title', page.title],
          ['meta.url', page.url],
          ['meta.image', page.source.dig('original', 'source')],
          ['meta.thumb', page.source.dig('thumbnail', 'source')],
          ['meta.wikidata', page.source['wbentityusage']&.keys&.first&.yield_self { |id| id && Link.new('wikidata', id) }]
        ].select(&:last)
      end

      AUX_VARIABLES = /(footnote|_ref$|_note$)/

      def parse_infoboxes(page)
        # TODO: if there are several infoboxes, prefix variables
        page.templates(name: /(^infobox|box$)/i)
          .reject { |i| i.name.match(/(^Color | image$)/i) || !i.in_sections.empty? }
          .flat_map { |infobox|
            [['infobox_name', infobox.name]] +
              infobox.named_variables.map(&method(:infobox_variable)).compact
          }
      end

      def infobox_variable(var)
        return if var.name =~ AUX_VARIABLES
        # TODO:
        # return parse_infobox(var) if var.name == 'module'

        Simplifier.call(var.children)
          .yield_self(&method(:split_lines))
          .map { |nodes| Parsers.nodes(nodes, var.name) }
          .yield_self { |values|
            return if values.none?
            [var.name, values.one? ? values.first : values, source: var]
          }
      end

      def split_lines(nodes)
        nodes.chunk { |n| W(:HTMLTag, tag: 'br') === n }
          .reject(&:first).map(&:last).map(&Infoboxer::Tree::Nodes.method(:new))
      end
    end
  end
end

%w[simplifier templates parsers name_joiner].each { |f| require_relative "wikipedia/#{f}" }

# FIXME: :philosoraptor:
Reality.describers[:wikipedia] = Reality::Describers::Wikipedia.new
