module Reality
  require_ %w[entity/coercion entity/wikidata_predicates entity/wikipedia_type]

  # Reality::Entity is a main concept of the library. It represents errr
  # well, some entity from real world. You can think of it as of rough
  # equivalent of Wikipedia article.
  #
  # Wiki has more details about entity [concept](https://github.com/molybdenum-99/reality/wiki/Entity)
  # and [internals](https://github.com/molybdenum-99/reality/wiki/Entity%20internals).
  #
  # The easiest way to have an entity is to instantiate is as {Entity.load}
  # (also aliased as `Reality.Entity()` method): you'll just have your
  # entity already _loaded_ from all possible data sources (or `nil` if
  # neither of them knows about it):
  #
  # ```ruby
  # argentina = Reality::Entity('Argentina')
  # # => #<Reality::Entity(Argentina):country>
  # ```
  # Then, you can use {#describe} to see what properties entity has, and
  # call any of them by name, like `argentina.capital`.
  #
  # Or you can create not loaded entities with just {#initialize} (it
  # may be useful when you want to further batch-load several of them 
  # through {List#load!}).
  #
  class Entity
    using Refinements
    
    attr_reader :wikipage, :wikidata, :wikidata_id
    attr_reader :values, :wikipedia_type

    # Initializes entity and extends properties from data sources
    #
    # Examples:
    #   Reality::Entity.new('Mississippi')
    #     => #<Reality::Entity?(Mississippi)>
    #   Reality::Entity.new('Mississippi', load: true)
    #     => #<Reality::Entity(Mississippi)>
    #
    # @param name [String]
    # @param wikidata_id [String] - optional
    #def initialize(name, wikipage: nil, wikidata: nil, wikidata_id: nil, load: false)
    def initialize(name, wikidata_id: nil)
      @name = name
      @wikidata_id = wikidata_id
      @values = {}
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
    # Example:
    #
    # ```
    # $> Reality::Entity.new('Mississippi').describe
    #   Output:
    #   -------------------------------
    #   <Reality::Entity(Mississippi)>
    #   -------------------------------
    #          capital: #<Reality::Entity?(Jackson)>
    #            coord: #<Reality::Geo::Coord(33°0′0″N,90°0′0″W)>
    #          country: #<Reality::Entity?(United States of America)>
    #       created_at: Wed, 10 Dec 1817
    #       located_in: #<Reality::Entity?(United States of America)>
    #       neighbours: #<Reality::List[Alabama?, Tennessee?, Louisiana?, Arkansas?]>
    # official_website: "http://www.mississippi.gov"
    #        tz_offset: #<Reality::TZOffset(UTC-06:00)>
    # ```
    def describe
      puts _describe
      nil
    end

    def to_s
      name
    end

    # @private
    def to_s?
      # FIXME: fuuuuuuuu
      "#{name.include?(',') ? '"' + name + '"' : name}#{loaded? ? '' : '?'}"
    end

    # Loads wikipage and wikidata by wikidata_id or entity name
    # We try to lazy-load data so this method is executed on demand
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

    # Returns true if at least 1 main data source - wikipedia page or wikidata - is loaded
    #
    # @return [true, false]
    def loaded?
      !!(@wikipage || @wikidata)
    end

    # @private
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

    def respond_to?(sym, include_all = false)
      sym !~ /[=?!]/ && !UNSUPPORTED_METHODS.include?(sym) || super(sym)
    end

    class << self
      # Initializes Entity and loads it's data
      #
      # @param name [String]
      #
      # @return [Entity]
      def load(name)
        Entity.new(name).load!.tap{|entity|
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
