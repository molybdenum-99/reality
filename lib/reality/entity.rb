module Reality
  require_ %w[entity/class entity/properties entity/list]
  
  class Entity
    using Refinements
    
    attr_reader :name, :entity_class
    
    def initialize(name, wikipage: nil, wikidata: nil, load: false)
      @name = name
      @wikipage, @wikidata = wikipage, wikidata
      load! if load # TODO: only partial load, like {load: :wikipage}
      after_load if @wikipage
    end

    def inspect
      "#<#{entity_class || self.class}(#{name})>"
    end

    def to_s
      name
    end

    def wikipage
      load! unless @wikipage
      @wikipage ||= Infoboxer.wikipedia.get(name)
    end

    def wikidata
      load! unless @wikidata
      @wikidata
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

    class << self
      def load(name, entry_class = nil)
        Entity.new(name, load: true).tap{|entity|
          return nil if entity.instance_variable_get('@wikipage').nil?
          return nil if entry_class && entity.entity_class != entry_class
        }
      end
    end

    def to_h
      if respond_to?(:properties)
        properties.map{|sym|
          [sym, to_simple_type(self.send(sym))]
        }.to_h
      else
        {}
      end
    end

    protected

    def after_load
      if @wikipage && !@entity_class
        @entity_class = EntityClass.for(self)
        extend(@entity_class) if @entity_class
      end
    end

    def values
      @values ||= {}
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
