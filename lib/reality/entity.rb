module Reality
  class Entity
    using Refinements
    
    attr_reader :name
    
    def initialize(name, wikipage: nil, wikidata: nil, load: false)
      @name = name
      @wikipage, @wikidata = wikipage, wikidata
      load! if load # TODO: only partial load
    end

    def inspect
      "#<#{self.class}(#{name})>"
    end

    def to_s
      name
    end

    def wikipage
      @wikipage ||= Infoboxer.wikipedia.get(name)
    end

    def wikidata
      @wikidata ||= Wikidata::Entity.fetch(name).first # FIXME: select by type?
    end

    def load!(what = [:wikidata, :wikipage])
      what.each{|w| send w}
    end

    class << self
      def properties
        @properties ||= []
      end
      
      def property(name, **opts)
        opts[:type] ||= :string
        properties << name
        define_method(name){
          fetch(**opts)
        }
      end
    end

    def to_h
      self.class.properties.map{|sym|
        [sym, to_simple_type(self.send(sym))]
      }.to_h
    end

    protected

    def fetch(**opts)
      if opts[:wikidata]
        coerce(opts[:type], wikidata[opts[:wikidata]], **opts.except(:type, :wikidata))
      elsif opts[:wikipedia]
        coerce(opts[:type], wikipage.infobox.fetch(opts[:wikipedia]), **opts.except(:type, :wikipedia))
      else
        fail "Can't fetch anything except wikidata and wikipedia, sorry!"
      end
    end

    def coerce(type, data, **opts)
      if data.kind_of?(Array) && !type.kind_of?(Array)
        data = data.first
      end

      if opts[:parse]
        data = opts[:parse].call(data)
      end

      # FIXME: better errors: including field name & class name
      case type
      when Array
        type.count == 1 or fail("Only homogenous array types supported, #{type.inspect} received")
        data.kind_of?(Array) or fail("Array type expected, #{data.inspect} received")
        data.map{|row| coerce(type.first, row, **opts)}
      when :entity
        coerce_entity(data)
      when :measure
        u = opts[:unit] || opts[:units] or fail("Units are not defined for measure type")
        Measure.coerce(Util::Parse.number(data.to_s), u)
      when :string
        data.to_s
      when :utc_offset
        data.to_s.sub(/^UTC/, '').tr('−', '-').to_i # FIXME: definitely too naive
      when :coord
        data.is_a?(Geo::Coord) ? data : nil
      else
        fail ArgumentError, "Can't coerce #{data.inspect} to #{type.inspect}"
      end
    end

    def coerce_entity(obj)
      case obj
      when Wikidata::Link
        Entity.new(obj.label || obj.id)
      else
        fail ArgumentError, "Can't coerce #{obj.inspect} to Entity"
      end
    end

    def to_simple_type(val)
      case val
      when nil, Numeric, String, Symbol
        val
      when Array
        val.map{|v| to_simple_type(v)}
      when Hash
        val.map{|k, v| [to_simple_type(k), to_simple_type(v)]}.to_h
      when Entity
        val.to_s
      when Reality::Measure
        val.amount.to_i
      else
        fail ArgumentError, "Non-coercible value #{val.class}"
      end
    end

  end
end

__END__
  EntityTypeError = Class.new(NameError)
  
  class Entity
    def initialize(name, page = nil)
      @name = name
      @wikipedia_page = page
    end

    def name
      loaded? ? @wikipedia_page.title : @name
    end

    def to_s
      name
    end

    def inspect
      "#<#{self.class}#{loaded? ? '' : '?'}(#{name})>"
    end

    def to_h
      self.class::PROPERTIES.
        map{|prop| [prop, to_simple_type(send(prop))]  }.
        #reject{|prop, val| !val || val.respond_to?(:empty?) && val.empty?}.
        to_h
    end

    def loaded?
      !!@wikipedia_page
    end

    def load!
      @wikipedia_page ||= Infoboxer.wikipedia.get(name).
        tap{|page|
          expected = self.class.infobox_name
          actual = page.infobox.name
          if expected && actual != expected
            raise EntityTypeError, "Expected infobox #{expected}, page with #{actual} fetched"
          end
        }
    end

    def wikipedia_page
      load!
      @wikipedia_page
    end

    class << self
      def infobox_name(name = nil)
        return @infobox_name unless name
        @infobox_name = name
      end

      def load(name)
        page = Infoboxer.wikipedia.get(name) or return nil
        expected = self.infobox_name
        actual = page.infobox.name
        if !expected || actual == expected
          new(name, page)
        else
          nil
        end
      end

      def from_wikilink(link)
        new(link.link)
      end
    end

    protected

    def infobox
      wikipedia_page.infobox
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
      when Reality::Entity
        val.name
      when Reality::Measure
        val.amount.to_i
      else
        fail ArgumentError, "Non-coercible value #{val.class}"
      end
    end
  end
end
