module Reality
  require_ %w[entity/class entity/properties entity/list entity/coercion entity/wikidata]
  
  class Entity
    using Refinements
    
    attr_reader :values, :entity_class
    attr_reader :wikipage, :wikidata
    
    def initialize(name, wikipage: nil, wikidata: nil, load: false)
      @name = name
      @wikipage, @wikidata = wikipage, wikidata
      @values = {}
      
      load! if load
      after_load if @wikipage
    end

    def name
      @wikipage ? @wikipage.title : @name
    end

    def inspect
      "#<#{self.class}#{loaded? ? '' : '?'}(#{name})>"
    end

    def to_s
      name
    end

    def load!
      @wikipage = Infoboxer.wikipedia.get(name)
      if @wikipage
        @wikidata = Wikidata::Entity.fetch(@wikipage.title).first
      end
      after_load
    end

    def loaded?
      !!@wikipage
    end

    def method_missing(sym, *arg, **opts, &block)
      if arg.empty? && opts.empty? && !block && sym !~ /[=?!]/
        load! unless loaded?
        values[sym]
      else
        super
      end
    end

    class << self
      def load(name, entry_class = nil)
        Entity.new(name, load: true).tap{|entity|
          return nil if entity.instance_variable_get('@wikipage').nil?
          return nil if entry_class && entity.entity_class != entry_class
        }
      end
    end

    #def to_h
      #if respond_to?(:properties)
        #properties.map{|sym|
          #[sym, to_simple_type(self.send(sym))]
        #}.to_h
      #else
        #{}
      #end
    #end

    protected

    def after_load
      if @wikipage && !@entity_class
        @entity_class = EntityClass.for(self)
        extend(@entity_class) if @entity_class
      end
      if @wikidata
        @values.update(WikidataProperties.parse(@wikidata))
      end
    end

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
