module Reality
  require_ %w[entity/class entity/properties]
  
  class Entity
    using Refinements
    
    attr_reader :name
    
    def initialize(name, wikipage: nil, wikidata: nil, load: false)
      @name = name
      @wikipage, @wikidata = wikipage, wikidata
      load! if load # TODO: only partial load, like {load: :wikipage}
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

    include EntityProperties

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
