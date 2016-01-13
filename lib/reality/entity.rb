module Reality
  class Entity
    def initialize(page)
      @page = page
    end

    def to_s
      name
    end

    def inspect
      "#<#{self.class}(#{name})>"
    end

    def to_h
      self.class::PROPERTIES.
        map{|prop| [prop, to_simple_type(send(prop))]  }.
        #reject{|prop, val| !val || val.respond_to?(:empty?) && val.empty?}.
        to_h
    end

    protected

    attr_reader :page

    def infobox
      page.infobox
    end

    def infobox_links(varname)
      src = infobox.fetch(varname)
      if tmpl = src.lookup(:Template, name: /list$/).first
        # values could be both inside and outside list, see India's cctld value
        src = Infoboxer::Tree::Nodes[src, tmpl.variables] 
      end
      src.lookup(:Wikilink).uniq
    end

    def fetch_named_measure(varname, measure)
      src = infobox.fetch(varname).text.strip
      src.empty? ? nil : Reality::Measure(parse_maybe_scaled(src), measure)
    end

    def fetch_coord_dms
      # FIXME: check if coords exist at all
      Geo::Coord.from_dms(
        [
          infobox.fetch('latd').text.strip.to_i,
          infobox.fetch('latm').text.strip.to_i,
          infobox.fetch('lats').text.strip.to_f,
          infobox.fetch('latNS').text.strip
        ],
        [
          infobox.fetch('longd').text.strip.to_i,
          infobox.fetch('longm').text.strip.to_i,
          infobox.fetch('longs').text.strip.to_f,
          infobox.fetch('longEW').text.strip
        ]
      )
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

    def parse_scaled(str)
      match, amount, scale = */^([0-9.,]+)[[:space:]]*(#{SCALES_REGEXP})/.match(str)
      match or
        fail(ArgumentError, "Unparseable scaled value #{str} for #{self}")

      (amount.gsub(/[,]/, '').to_f * fetch_scale(scale)).to_i
    end

    def parse_maybe_scaled(str)
      match, amount, scale = */^([0-9.,]+)[[:space:]]*(#{SCALES_REGEXP})?/.match(str)
      match or
        fail(ArgumentError, "Unparseable scaled value #{str} for #{self}")

      if scale
        (amount.gsub(/[,]/, '').to_f * fetch_scale(scale)).to_i
      else
        amount.gsub(/[,]/, '').to_i
      end
    end

    def fetch_scale(str)
      _, res = SCALES.detect{|key, val| str.start_with?(key)}

      res or fail("Scale not found: #{str} for #{self}")
    end

    def to_simple_type(val)
      case val
      when nil, Numeric, String, Symbol
        val
      when Array
        val.map{|v| to_simple_type(v)}
      when Hash
        val.map{|k, v| [to_simple_type(k), to_simple_type(v)]}.to_h
      when Infoboxer::Tree::Wikilink
        val.link
      when Infoboxer::Tree::Node
        val.text_
      when Reality::Measure
        val.amount.to_i
      else
        fail ArgumentError, "Non-coercible value #{val.class}"
      end
    end
  end
end
