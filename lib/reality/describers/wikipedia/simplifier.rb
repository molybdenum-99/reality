module Reality
  module Describers
    class Wikipedia
      module Simplifier
        extend Infoboxer::Navigation::Helpers

        module_function

        def call(nodes)
          nodes.flat_map(&method(:unwrap))
            .yield_self(&method(:remove_aux))
            .yield_self(&method(:strip))
        end

        WRAPPERS = [
          W(:Italic),
          W(:Bold),
          W(:BoldItalic)
        ].freeze

        WRAP_TEMPLATES = [
          W(:Template, name: 'nowrap'),
          W(:Template, name: 'nobold')
        ].freeze

        LIST_TEMPLATES = [
          W(:Template, name: /list$/),
          W(:Template, name: 'ubl')
        ]

        AUX_NODES = [
          W(:Ref),
          W(:Template, name: 'small'),
          W(:Template, name: 'lower'),
          W(:Template, name: 'smallsup'),
          W(:HTMLTag, tag: 'sup'),
          W(:HTMLTag, tag: 'small'),
          W(:Template, name: /^(decrease|increase)$/i),
          W(:Template, name: 'RP'),
          W(:Template, name: /^(ref|efn)/i),
        ].freeze

        # TODO: replace
        SIMPLE_TEMPLATES = {
          W(:Template, name: '!') => Infoboxer::Tree::Text.new('|'),
          W(:Template, name: '\\') => Infoboxer::Tree::Text.new('/'),
        }.freeze

        def unwrap(node)
          if WRAPPERS.any? { |wrap| wrap === node }
            node.children.flat_map(&method(:unwrap))
          elsif WRAP_TEMPLATES.any? { |wrap| wrap === node }
            node.unnamed_variables.first.children.flat_map(&method(:unwrap))
          elsif W(:List) === node
            node.children.map(&:children)
              .yield_self { |items| ajoin(items, Infoboxer::Tree::HTMLTag.new('br', {})) }
              .flat_map(&method(:unwrap))
          elsif LIST_TEMPLATES.any? { |list| list === node }
            node.unnamed_variables.map(&:children).map(&method(:strip))
              .yield_self { |items| ajoin(items, Infoboxer::Tree::HTMLTag.new('br', {})) }
              .flat_map(&method(:unwrap))
          else
            node
          end
        end

        def remove_aux(nodes)
          nodes.reject { |n| AUX_NODES.any? { |type| type === n } }
        end

        def strip(nodes)
          # TODO: if spaces at beginning of first, at the end of last, if they are Text
          nodes = nodes.dup
          nodes.pop while !nodes.empty? && blank_node?(nodes.last)
          nodes.shift while !nodes.empty? && blank_node?(nodes.first)
          nodes
        end

        def blank_node?(node)
          # TODO: W() | W() in infoboxer
          W(:Text, text: /^[[:space:]]*$/) === node ||
            W(:HTMLTag, tag: /^w?br/) === node
        end

        def ajoin(arrays, splitter)
          arrays[0..-2].map { |a| [*a, splitter] }.flatten(1) + arrays[-1]
        end
      end
    end
  end
end
