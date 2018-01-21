require 'infoboxer'
require 'money'
require 'tz_offset'

module Reality
  #using Refinements

  module DataSources
    class Wikipedia
      extend Memoist

      def get(title)
        internal.get(title).yield_self(&method(:parse_infobox))
      end

      memoize def log
        Logger.new(STDOUT)
      end

      private

      memoize def internal
        Infoboxer.wp
      end

      def parse_infobox(page)
        infobox = page.templates(name: /(^infobox|box$)/i).reject { |i| i.name.end_with?('image') }.first
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

      def try_parce_percents(lines)
        return unless lines.all? { |l| l =~ /^\s*\d+(\.\d+)?\s*%\s*(.+)$/ }
        lines.map { |l| l.scan(/^\s*(\d+(?:\.\d+)?)\s*%\s*(.+)$/).flatten }
          .map { |pct, title| [title, pct.to_f] }
          .to_h
      end

      def self.sel(*arg, &block)
        Infoboxer::Navigation::Lookup::Selector.new(*arg, &block)
      end

      AUX_NODES = [
        sel(:Ref),
        sel(:Template, name: 'small'),
        sel(:Template, name: 'lower'),
        sel(:Template, name: 'smallsup'),
        sel(:HTMLTag, tag: 'sup'),
        sel(:HTMLTag, tag: 'small'),
        sel(:Template, name: /^(decrease|increase)$/i),
        sel(:Template, name: 'RP'),
        sel(:Template, name: /^efn/i),
      ].freeze

      SIMPLE_TEMPLATES = {
        sel(:Template, name: '!') => Infoboxer::Tree::Text.new('|'),
        sel(:Template, name: '\\') => Infoboxer::Tree::Text.new('/'),
      }.freeze

      def cleanup(nodes)
        nodes
          .reject { |n| AUX_NODES.any? { |type| type === n } }
          .flat_map(&method(:unwrap))
          .map { |n| SIMPLE_TEMPLATES.detect { |key, _| key === n }&.last || n }
          .tap { |res| res.pop while sel(:HTMLTag, tag: /^w?br/) === res.last }
          .tap { |res| res.pop while sel(:Text, text: /^[[:space:]]*$/) === res.last }
      end

      def unwrap(node)
        case node
        when sel(:Template, name: 'nowrap'), sel(:Template, name: 'nobold')
          cleanup(node.unnamed_variables.first.children)
        when sel(:Italic)
          cleanup(node.children)
        else
          node
        end
      end

      def textual?(node)
        case node
        when sel(:Text), sel(:Wikilink), sel(:HTMLTag, tag: /^w?br/), sel(:ExternalLink)
          true
        else
          false
        end
      end

      def process_singular(node)
        case node
        when sel(:Text)
          node.to_s
        when sel(:Wikilink)
          "#<Link[#{node.link}]>"
        when sel(:Template, name: /^coord$/i)
          parse_coord(node.unnamed_variables.map(&:text))
        when sel(:Template, name: /list$/), sel(:Template, name: 'ubl')
          items = node.unnamed_variables.map(&:children)
          if items.all? { |i| i.text =~ /^\s*\d+(\.\d+)?\s*%\s*(.+)$/ }
            items.map { |i| i.text.scan(/^\s*(\d+(?:\.\d+)?)\s*%\s*(.+)$/).flatten }
              .map { |pct, title| [title, pct.to_f] }
              .to_h
          else
            items.map(&method(:process_value))
          end
        when sel(:Template, name: /^(start|birth|end) date/i)
          Date.new(*node.unnamed_variables.map(&:text).first(3).map(&:to_i))
        when sel(:Template, name: 'convert')
          val, unit = node.unnamed_variables.map(&:text).first(2)
          unit.gsub!(/2$/, '²')
          Measure[unit].new(val.to_i)
        when sel(:ExternalLink)
          node.link
        when sel(:Template, name: 'url')
          "http://#{node.variables.text}"
        when sel(:Template, name: /^flag(country)?$/)
          "#<Link[#{node.variables.text}]>"
        else
          log.debug "Unparseable singular: #{node.to_tree}"
          '?'
        end
      end

      def parse_coord(vals)
        vals = vals.grep_v(/:/)
        num = vals.count == 2 ? 2 :
          vals.index('E') || vals.index('W') or fail("Unparseable coord #{vals.inspect}")
        vals = vals.first(num + 1).map { |t| t =~ /[SNEW]/ ? t : t.to_f }
        names = case vals.count
        when 8
          %i[latd latm lats lath lngd lngm lngs lngh]
        when 6
          %i[latd latm lath lngd lngm lngh]
        when 4
          %i[lat lath lng lngh]
        when 2
          %i[lat lng]
        else
          fail("Unparseable coord #{vals.inspect}")
        end
        Geo::Coord.new(names.zip(vals).to_h)
      end

      def process_node(node)
        case node
        when sel(:Text)
          node.to_s
        #when sel(:Template, name: 'Plainlist')
          #puts node.to_tree
        when sel(:Template, name: /list$/)
          node.unnamed_variables.flat_map(&:children).map(&method(:process_node))
        when sel(:UnorderedList)
          node.children.map(&method(:process_node))
        when sel(:Italic), sel(:BoldItalic)
          node.children.map(&method(:process_node))
        when sel(:Template, name: /^(nowrap|nobold)$/)
          node.variables.flat_map(&:children).map(&method(:process_node))
        when sel(:Wikilink)
          "#<Link[#{node.link}]>"
        when sel(:Template, name: /^(ref|efn|small)/), sel(:Ref), sel(:HTMLTag, tag: 'br')
             sel(:HTMLTag, tag: 'small')
          nil
        when sel(:Template, name: /^coord$/i)
          vals = node.unnamed_variables.map(&:text).map { |t| t =~ /[SNEW]/ ? t : t.to_i }
          num = vals.index('E') || vals.index('W') or fail("Unparseable coord #{node.inspect}")
          vals = vals.first(num + 1)
          names = case vals.count
          when 8
            %i[latd latm lats lath lngd lngm lngs lngh]
          when 6
            %i[latd latm lath lngd lngm lngh]
          else
            fail("Unparseable coord #{node.inspect}")
          end
          Geo::Coord.new(names.zip(vals).to_h)
        when sel(:Template, name: /^(start|birth|end) date/i)
          Date.new(*node.unnamed_variables.map(&:text).first(3).map(&:to_i))
        when sel(:Template, name: /^url$/i)
          'http://' + node.unnamed_variables.first.children.text
        else
          node.inspect
        end
      end

      def postprocess_value(name, value)
        return value.map { |v| postprocess_value(name, v) } if value.is_a?(Array)
        return value unless value.is_a?(String) || value.is_a?(ValueOrText)

        guess = try_guess_by_name(name, value) and return guess
        str = value.is_a?(ValueOrText) ? value.value : value.strip

        case str
        when /^\d{1,2}[[:space:]]+(\w+)[[:space:]]+\d{4}([[:space:]]+BCE)?$/, /^(\w+)[[:space:]]+\d{1,2},[[:space:]]+\d{4}([[:space:]]+BCE)?$/
          Date.parse(str).inspect
        when /^\d+$/
          str.to_i
        when /^\d+\.\d+$/
          str.to_f
        when /^\d{1,3},(\d{3},)*\d{3}$/
          str.gsub(',', '').to_i
        when /^\$(\d{1,3},(\d{3},)*\d{3})$/
          val = Regexp.last_match[1].gsub(',', '').to_i
          Measure['$'].new(val)
        when /^\$(?<num>(\d{1,3},(\d{3},)*\d{3}|\d+)(\.\d+)?)[[:space:]]+(?<scale>#{SCALES_REGEXP})/
          num, scale = Regexp.last_match[:num], Regexp.last_match[:scale]
          val = (num.gsub(',', '').to_f * fetch_scale(scale)).to_i
          Measure['$'].new(val)
        else
          value # returning entire ValueOrText, if it is present!
        end.yield_self { |val| try_make_measure(name, val) }
      end

      def try_guess_by_name(name, val)
        value = val.to_s
        case name
        when /^utc_offset/
          if value.include?('/')
            value.split(%r{\s*/\s*}).map(&TZOffset.method(:parse))
              .yield_self { |offsets| offsets.any?(&:nil?) ? value : offsets }
          else
            TZOffset.parse(value) || value
          end
        when /_rank$/
          value =~ /^\d/ ? value.to_i : value
        end
      end

      def try_make_measure(name, val)
        return val unless val.is_a?(Numeric)
        case name
        when /^population_density_(.*)km2$/
          'people/km²'
        when /^population_(?!density|as_of)/
          'people'
        when /(?<!density)_km2$/
          'km²'
        when /_m$/
          'm'
        end.yield_self { |unit| unit ? Measure[unit].new(val) : val }
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

      def unpack(val)
        val.is_a?(ValueOrText) ? val.value : val
      end

      def nameify(name)
        # TODO: "mayor and head of city administration" → [mayor, head of city adm]
        name.downcase.gsub(/\([^)]+\)/, '').gsub(/[^a-z_0-9]/, '_').sub(/(^_+|_+$)/, '')
      end

      # See "Short scale": https://en.wikipedia.org/wiki/Long_and_short_scales#Comparison
      SCALES = {
        'million'     => 1_000_000,
        'billion'     => 1_000_000_000,
        'trillion'    => 1_000_000_000_000,
        'quadrillion' => 1_000_000_000_000_000,
        'quintillion' => 1_000_000_000_000_000_000,
        'sextillion'  => 1_000_000_000_000_000_000_000,
        'septillion'  => 1_000_000_000_000_000_000_000_000,
      }
      SCALES_REGEXP = Regexp.union(*SCALES.keys)

      def fetch_scale(str)
        _, res = SCALES.detect{|key, val| str.start_with?(key)}

        res or fail("Scale not found: #{str} for #{self}")
      end

      def sel(*arg, &block)
        Infoboxer::Navigation::Lookup::Selector.new(*arg, &block)
      end
    end
  end
end
