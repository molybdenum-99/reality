module Reality
  require_ %w[entity/coercion entity/wikidata_predicates entity/wikipedia_type]
  
  class Entity
    using Refinements
    
    attr_reader :wikipage, :wikidata, :wikidata_id
    attr_reader :values, :wikipedia_type

    # Initializes entity and extends properties from data sources
    #
    # @param name [String]
    # @param wikipage [Infoboxer::MediaWiki::Page] - optional
    # @param wikidata [Reality::Wikidata::Entity] - optional
    # @param wikidata_id [String] - optional
    # @param load [true, false] - Executes fetching. Default: false
    def initialize(name, wikipage: nil, wikidata: nil, wikidata_id: nil, load: false)
      @name = name
      @wikipage, @wikidata, @wikidata_id = wikipage, wikidata, wikidata_id
      @values = {}
      
      load! if load
      after_load if @wikipage
    end

    # @return [String]
    def name
      @wikipage ? @wikipage.title : @name
    end

    def inspect
      if @wikipedia_type && @wikipedia_type.symbol
        "#<#{self.class}#{loaded? ? '' : '?'}(#{name}):#{@wikipedia_type.symbol}>"
      else
        "#<#{self.class}#{loaded? ? '' : '?'}(#{name})>"
      end
    end

    # Prints general object state and all properties with values
    #
    # @return [nil]
    def describe
      puts _describe
      nil
    end

    def to_s
      name
    end

    def to_s?
      # FIXME: fuuuuuuuu
      "#{name.include?(',') ? '"' + name + '"' : name}#{loaded? ? '' : '?'}"
    end

    # Loads wikipage and wikidata by wikidata_id or entity name
    #
    # @return [self]
    def load!
      if @wikidata_id
        @wikidata = Wikidata::Entity.one_by_id(@wikidata_id)
        if @wikidata && @wikidata.en_wikipage
          @wikipage = Infoboxer.wikipedia.get(@wikidata.en_wikipage)
        end
      else
        @wikipage = Infoboxer.wikipedia.get(name)
        @wikidata = if @wikipage
          Wikidata::Entity.one_by_wikititle(@wikipage.title)
        else
          Wikidata::Entity.one_by_label(name)
        end
      end
      after_load
      self
    end

    # Assigns pre-loaded data sources and extends entity properties
    #
    # @param wikidata
    # @param wikipage
    #
    # @return [self]
    def setup!(wikipage: nil, wikidata: nil)
      @wikipage, @wikidata = wikipage, wikidata
      after_load if @wikipage || @wikidata
      self
    end

    # Returns true if at least 1 main data source is loaded
    #
    # @return [true, false]
    def loaded?
      !!(@wikipage || @wikidata)
    end

    # Don't try to convert me!
    UNSUPPORTED_METHODS = [:to_hash, :to_ary, :to_a, :to_str, :to_int]

    def method_missing(sym, *arg, **opts, &block)
      if arg.empty? && opts.empty? && !block && sym !~ /[=?!]/ &&
        !UNSUPPORTED_METHODS.include?(sym)
        
        load! unless loaded?

        # now some new method COULD emerge while loading
        if methods.include?(sym)
          send(sym)
        else
          values[sym]
        end
      else
        super
      end
    end

    # Returns true for any method name except those that are not valid attributes
    # or unsupported operations
    #
    # @return [true, false]
    def respond_to?(sym)
      sym !~ /[=?!]/ && !UNSUPPORTED_METHODS.include?(sym) || super
    end

    class << self
      # Initializes Entity and loads it's data
      #
      # @param name [String]
      #
      # @return [Entity]
      def load(name)
        Entity.new(name, load: true).tap{|entity|
          return nil if !entity.loaded?
        }
      end
    end

    def to_h
      load! unless loaded?
      {name: name}.merge \
        values.map{|k, v| [k.to_sym, Coercion.to_simple_type(v)]}.to_h
    end

    def to_json
      to_h.to_json
    end

    protected

    def after_load
      if @wikipage && !@wikipedia_type
        if (@wikipedia_type = WikipediaType.for(self))
          extend(@wikipedia_type)
        end
      end
      if @wikidata
        @values.update(WikidataPredicates.parse(@wikidata))
      end
      (@values.keys - methods).each do |sym|
        define_singleton_method(sym){@values[sym]}
      end
    end

    def _describe
      load! unless loaded?
      Util::Format.describe(inspect, values.map{|k,v| [k, v.inspect]})
    end
  end
end
