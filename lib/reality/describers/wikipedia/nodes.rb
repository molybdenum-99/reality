module Reality
  module Describers
    class Wikipedia
      class Nodes
        extend Memoist
        extend Infoboxer::Navigation::Helpers

        PARSERS = {
          W(:Wikilink) => ->(n) { link(n.link) },
          W(:ExternalLink) => ->(n) { n.link },

          W(:Template, name: /^coord$/i) => Templates.method(:coord),
          W(:Template, name: /^(start|birth|end) date/i) => Templates.method(:date),
          W(:Template, name: 'convert') => Templates.method(:convert),
          W(:Template, name: 'url') => ->(n) { "http://#{n.variables.text}" },
          W(:Template, name: /^flag(country)?$/) => ->(n) { link(node.variables.text) },
          W(:Template, name: /^[A-Z]{3}$/) => ->(n) { n.name } # Country ISO code, probably
        }

        attr_reader :label

        def initialize(nodes, label: nil)
          @nodes = nodes
          @label = label
        end

        def value
          value_or_text.yield_self do |val|
            return val unless val.is_a?(String)
            Parsers.text(val, label)
          end
        end

        def text
          @nodes.text.strip
        end

        alias to_s text

        private

        memoize def value_or_text
          return text if @nodes.count != 1
          _, parser = PARSERS.detect { |sel, _| sel === node }
          parser ? instance_exec(node, &parser) : node.text_
        end

        def node
          @nodes.first
        end

        def link(title)
          Link.new(:wikipedia, title)
        end
      end
    end
  end
end
