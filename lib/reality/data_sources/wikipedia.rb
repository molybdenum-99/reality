require 'infoboxer'
require 'money'
require 'tz_offset'

module Reality
  using Refinements

  module DataSources
    class Wikipedia
      def get(title)
        internal.get(title).derp(&method(:parse_infobox))
      end

      private

      def internal
        @internal ||= Infoboxer.wp
      end

      def parse_infobox(page)
        infobox = page.templates(name: /(^infobox|box$)/i).reject { |i| i.name.end_with?('image') }.first
        [[:infobox, infobox.name]] + infobox.variables.flat_map(&method(:infobox_variable))
      end

      def infobox_variable(var)
        return if var.name =~ /(footnote|_ref$|_note$)/
        return parse_infobox(var) if var.name == 'module'

        @v = var.name
        [process_value(var.children)].flatten
          .flat_map { |val| postprocess_value(var.name, val) }
          .compact
          .map { |val| [var.name.downcase.gsub(/[^a-z_0-9]/, '_'), val] }
      end

      def process_value(nodes)
        nodes = cleanup(nodes)
        #p nodes.to_a if @v == 'government_type'
        if nodes.count == 1
          process_singular(nodes.first)
        elsif nodes.all?(&method(:textual?))
          text = nodes.text.strip
          return text unless text.include?("\n")
          lines = text.split("\n").map(&:strip).reject(&:empty?)
          if lines.all? { |l| l =~ /^\s*\d+(\.\d+)?\s*%\s*(.+)$/ }
            lines.map { |l| l.scan(/^\s*(\d+(?:\.\d+)?)\s*%\s*(.+)$/).flatten }
              .map { |pct, title| [title, pct.to_f] }
              .to_h
          else
            lines
          end
        else
          '???'
        end
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
        when sel(:Text), sel(:Wikilink), sel(:HTMLTag, tag: /^w?br/)
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
        else
          '?'
        end
      end

      def parse_coord(vals)
        num = vals.index('E') || vals.index('W') or fail("Unparseable coord #{node.inspect}")
        vals = vals.first(num + 1).map { |t| t =~ /[SNEW]/ ? t : t.to_i }
        names = case vals.count
        when 8
          %i[latd latm lats lath lngd lngm lngs lngh]
        when 6
          %i[latd latm lath lngd lngm lngh]
        else
          fail("Unparseable coord #{node.inspect}")
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
        if name.end_with?('_km2') && !name.end_with?('density_km2')
          return Measure['km²'].new(value.gsub(',', '').to_i)
        end

        if name.end_with?('_m')
          return Measure['m'].new(value.to_i)
        end

        if name.start_with?('utc_offset')
          if value.include?('/')
            return value.split(%r{\s*/\s*}).map(&TZOffset.method(:parse))
              .derp { |offsets| offsets.any?(&:nil?) ? value :offsets }
          else
            return TZOffset.parse(value) || value
          end
        end

        if name.end_with?('_rank') && !value.empty?
          return value.to_i
        end

        case value
        when '', []
          nil
        when /^\d{1,2}[[:space:]]+(\w+)[[:space:]]+\d{4}([[:space:]]+BCE)?$/, /^(\w+)[[:space:]]+\d{1,2},[[:space:]]+\d{4}([[:space:]]+BCE)?$/
          Date.parse(value).inspect
        when /^\d+$/
          value.to_i
        when /^\d+\.\d+$/
          value.to_f
        when /^\d{1,3},(\d{3},)*\d{3}$/
          value.gsub(',', '').to_i
        when /^\$(\d{1,3},(\d{3},)*\d{3})$/
          val = Regexp.last_match[1].gsub(',', '').to_i
          Measure['$'].new(val)
        when /^\$(?<num>(\d{1,3},(\d{3},)*\d{3}|\d+)(\.\d+)?)[[:space:]]+(?<scale>#{SCALES_REGEXP})/
          num, scale = Regexp.last_match[:num], Regexp.last_match[:scale]
          val = (num.gsub(',', '').to_f * fetch_scale(scale)).to_i
          Measure['$'].new(val)
        when String
          value.strip
        when Array
          value.map { |v| postprocess_value(name, v) }
        else
          value
        end
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
