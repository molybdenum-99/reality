module Reality
  module Describers
    class Wikipedia < Abstract::MediaWiki
      extend Infoboxer::Navigation::Helpers
      include Infoboxer::Navigation::Helpers

      API_URL = Infoboxer.url_for(:wikipedia)

      private

      def parse_page(page)
        parse_infobox(page)
      end

      def parse_infobox(page)
        infobox = page.templates(name: /(^infobox|box$)/i).reject { |i| i.name.end_with?('image') }.first
        return unless infobox

        [['meta.infobox_name', infobox.name]] +
          infobox.variables.flat_map(&method(:infobox_variable))
          .compact
          .yield_self(&method(:convolve))
      end

      def infobox_variable(var)
        Simplifier.call(var.children)
          .yield_self(&method(:split_lines))
          .map { |nodes| ParsedNodes.new(nodes, label: var.name) }
      end

      PARSERS = {
        W(:Wikilink) => ->(n) { link(n.link) },
        W(:ExternalLink) => ->(n) { n.link },

        W(:Template, name: /^coord$/i) => Templates.method(:coord),
        W(:Template, name: /^(start|birth|end) date/i) => Templates[:date]
        W(:Template, name: 'convert') => Templates[:convert]
        W(:Template, name: 'url') => ->(n) { "http://#{n.variables.text}" }
        W(:Template, name: /^flag(country)?$/) => ->(n) { link(node.variables.text) }
      }

      class ParsedNodes
        extend Memoist

        def initialize(nodes, name: nil)
          @nodes = nodes
          @name = name
        end

        def value
          value_or_text.yield_self do |val|
            return val unless val.is_a?(String)
            try_parse_string(val)
          end
        end

        def text
          @nodes.text
        end

        private

        memoize def value_or_text
          return text if nodes.count != 1
          _, parser = PARSERS.detect { |sel, _| sel === node }
          parser ? instance_exec(node, &parser) : node.text
        end

        def node
          @nodes.first
        end
      end

      def split_lines(nodes)
        nodes.chunk { |n| W(:HTMLTag, tag: 'br') === n }
          .reject(&:first).map(&:last)
      end
    end
  end
end

__END__
      def parse_infobox(page)
        infobox = page.templates(name: /(^infobox|box$)/i).reject { |i| i.name.end_with?('image') }.first
        return unless infobox

        [['meta.infobox_name', infobox.name]] +
          infobox.variables.flat_map(&method(:infobox_variable))
          .compact
          .yield_self(&method(:convolve))
      end

      def infobox_variable(var)
        return if var.name =~ /(footnote|_ref$|_note$)/
        return parse_infobox(var) if var.name == 'module'

        [process_value(var.children)].flatten(1)
          .reject(&method(:empty_value?))
          .flat_map { |val| postprocess_value(var.name, val) }
          .compact
          .map { |val| [var.name, val] }
      end

      def empty_value?(val)
        val.nil? || val.respond_to?(:empty?) && val.empty?
      end

      ValueOrText = Struct.new(:value, :text) do
        def empty?
          text.empty?
        end

        def to_s
          text
        end
      end

      def process_value(nodes)
        nodes = cleanup(nodes)
        if nodes.count == 1
          ValueOrText.new(process_singular(nodes.first), nodes.first.text)
        elsif nodes.all?(&method(:textual?))
          text = nodes.text.strip
          return text unless text.include?("\n")
          lines = text.split("\n").map(&:strip).reject(&:empty?)
          try_parce_percents(lines) || lines
        else
          log.debug "Unparseable value: #{nodes.to_tree}"
          '???'
        end
      end

      CONVOLUTIONS = [
        [/^blank(?<number>\d+)?_name(?<section>_sec\d+)?$/, 'blank%{number}_info%{section}'],
        [/^(?<name>.+)_type(?<number>\d+)?$/, '%{name}_name%{number}'],
        [/^(?<name>.+)_title(?<number>\d+)?$/, '%{name}_name%{number}'],
        [/^(?<name>.+)_title(?<number>\d+)?$/, '%{name}_date%{number}'],
        [/^(?<prefix>.+)_blank(?<number>\d+)?_title$/, '%{prefix}_blank%{number}'],
        [/^(?<name>.+)_type(?<number>\d+)?$/, '%{name}%{number}'],
      ]

      def convolve(pairs)
        extract_convolved(pairs)
          .map { |name, val| [nameify(name), unpack(val)] }
      end

      def extract_convolved(pairs)
        remove = []
        replace = {}
        pairs.each_with_index do |(name, value), i|
          CONVOLUTIONS
            .select { |name_pat, val_pat| name.match(name_pat) }
            .each do |name_pat, val_pat|
              match = match_hash(name, name_pat)
              val_name = val_pat % match
              val_candidates = pairs.select { |name, _| name == val_name }
              next if val_candidates.empty?
              result_name = [match['prefix'], value.to_s].compact.join('_')
              log.debug "Convolving #{name} with #{val_name} to #{result_name} (#{val_candidates.count} values)"

              remove << val_name
              replace[name] = val_candidates.map { |_, val| [result_name, val] }
              break
            end
        end
        pairs.map { |name, value|
          if remove.include?(name)
            []
          elsif replace.key?(name)
            replace[name]
          else
            [[name, value]]
          end
        }.flatten(1)
      end

      def match_hash(str, pattern)
        m = str.match(pattern) or return nil
        m.names.map(&:to_sym).zip(m.captures).to_h
      end
    end
  end
end
