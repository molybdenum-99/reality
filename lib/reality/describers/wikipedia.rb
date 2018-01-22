module Reality
  module Describers
    class Wikipedia < Abstract::MediaWiki
      include Infoboxer::Navigation::Helpers

      API_URL = Infoboxer.url_for(:wikipedia)

      private

      def descriptor
        :wikipedia
      end

      def parse_page(page)
        parse_infoboxes(page)
          .map { |label, value| obs(page.title, label, value) }
      end

      AUX_VARIABLES = /(footnote|_ref$|_note$)/

      def parse_infoboxes(page)
        # TODO: if there are several infoboxes, prefix variables
        page.templates(name: /(^infobox|box$)/i)
          .reject { |i| i.name.end_with?('image') || !i.in_sections.empty? }
          .flat_map { |infobox|
            [['meta.infobox_name', infobox.name]] +
              infobox.named_variables.flat_map(&method(:infobox_variable))
                .compact
                .yield_self(&NameJoiner.method(:call))
                .map { |name, var| [name, var.value] }
          }
      end

      def infobox_variable(var)
        return if var.name =~ AUX_VARIABLES
        # TODO:
        # return parse_infobox(var) if var.name == 'module'

        Simplifier.call(var.children)
          .tap { |res| p res if var.name == '______' }
          .yield_self(&method(:split_lines))
          .map { |nodes| Nodes.new(nodes, label: var.name) }
      end

      def split_lines(nodes)
        nodes.chunk { |n| W(:HTMLTag, tag: 'br') === n }
          .reject(&:first).map(&:last).map(&Infoboxer::Tree::Nodes.method(:new))
      end
    end
  end
end

%w[simplifier parsers name_joiner templates nodes].each { |f| require_relative "wikipedia/#{f}" }

# FIXME: :philosoraptor:
Reality.describers[:wikipedia] = Reality::Describers::Wikipedia.new
