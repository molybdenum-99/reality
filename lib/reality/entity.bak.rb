module Reality
  require_ %w[entity/coercion entity/wikidata_predicates entity/wikipedia_data entity/extension]

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

    # Instance of Infoboxer's [page](http://www.rubydoc.info/gems/infoboxer/Infoboxer/MediaWiki/Page).
    #
    # Pretty useful on its own:
    #
    # ```ruby
    # puts Reality::Entity('Argentina').wikipage.intro
    # # Argentina (ˌɑrdʒənˈtiːnə; aɾxenˈtina), officially the Argentine Republic (República Argentina), is a federal republic....
    # ```
    #
    # Refer to [Infoboxer's documentation](http://www.rubydoc.info/gems/infoboxer/Infoboxer/MediaWiki/Page)
    # for details.
    #
    # @return [Infoboxer::MediaWiki::Page]
    attr_reader :wikipage

    # All values extracted from data sources, in structured form.
    # You can pretty-previes them via {#describe}, as well as work with
    # separate values with method call (see {#method_missing}).
    #
    # @return [Hash<Symbol, Object>]
    attr_reader :values

    # @private
    attr_reader :wikipedia_type, :wikidata, :wikidata_id

    # Creates new entity. Initially, entity is _not_ loaded from datasources,
    # it's just a name. If you want to receive a loaded entity with one
    # statement, take a look at {Entity.load}, which does `new` + `load!`
    # under the hoods.
    #
    # ```
    # e = Reality::Entity.new('Mississippi')
    # # => #<Reality::Entity?(Mississippi)>
    # e.loaded?
    # # => false
    # e.values
    # # => {}
    # ```
    #
    # @param name [String] Name of the entity you want. Basically, it's
    #   Wikipedia page name for some concept. Not-so-basically, please
    #   refer to [names explanation](https://github.com/molybdenum-99/reality/wiki/Entity#entity-names)
    #   in our wiki.
    # @param wikidata_id [String] Used mostly internally (when not only
    #   entity name, but also wikidata id is known; this happens on loading
    #   entities by references from other entities).
    def initialize(name, wikidata_id: nil)
      @name = name
      @wikidata_id = wikidata_id
      @values = {}
    end

    # Entity name string. For not loaded entity returns the name by which it
    # was created. For loaded, it's correct name of Wikipedia page:
    #
    # ```ruby
    # e = Reality::Entity.new('Einstein')
    # # => #<Reality::Entity?(Einstein)>
    # e.name
    # # => "Einstein"
    # e.load!
    # # => #<Reality::Entity(Albert Einstein)>
    # e.name
    # # => "Albert Einstein"
    # ```
    #
    # @return [String]
    def name
      @wikipage ? @wikipage.title : @name
    end

    # Returns entity brief representation. Things to note:
    #
    # ```
    # #<Reality::Entity?(Argentina)>
    #                  ^    ^
    #                  |  Entity name
    #             Sign of not
    #             loaded entity
    #
    # #<Reality::Entity(Argentina):country>
    #                  ^             ^
    #                  |           Name of "additional type" (to be documented...)
    #            No question mark:
    #            entity is loaded
    # ```
    #
    # @return [String]
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
    #
    # @return [nil]
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

    # Loads entity data from all external sources.
    #
    # Note that this method is called implicitly on {#method_missing},
    # {#describe} or {#to_h}.
    #
    # Note also that if you need several entities to be loaded, its much
    # more effective to have them grouped into {List} and batch-loaded
    # via {List#load!}.
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

    # @private
    def setup!(wikipage: nil, wikidata: nil)
      @wikipage, @wikidata = wikipage, wikidata
      after_load if @wikipage || @wikidata
      self
    end

    # Returns `true` if entity is loaded already.
    #
    # @return [Boolean]
    def loaded?
      !!(@wikipage || @wikidata)
    end

    # @private
    # Don't try to convert me!
    UNSUPPORTED_METHODS = [:to_hash, :to_ary, :to_a, :to_str, :to_int]

    # Entity handles `method_missing` this way:
    #
    # * loads itself if it was not loaded;
    # * returns one of {values} by method name.
    #
    # Note, that even if there's no value with required key, `method_missing`
    # will return `nil` (and not through `NoMethodError` as someone may
    # expect). That's because even supposedly homogenous entities may have different
    # property sets, and typically you want to do something like
    # `cities.map(&:area).compact.inject(:+)`, not handling exceptions
    # about "this city has no 'area' property".
    #
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

    # @private
    def respond_to?(sym, include_all = false)
      sym !~ /[=?!]/ && !UNSUPPORTED_METHODS.include?(sym) || super(sym)
    end

    class << self
      # Loads Entity from all datasources. Returns either loaded entity
      # or `nil` if entity not found.
      #
      # @param name [String] See {#initialize} for explanations about
      #   entity names.
      #
      # @return [Entity, nil]
      def load(name)
        Entity.new(name).load!.tap{|entity|
          return nil if !entity.loaded?
        }
      end
    end

    # Converts Entity to hash, preserving only _core types_ (so, you can
    # store this hash in YAML or JSON, for example). Some notes on conversion:
    # * Entity name goes to `:name` key;
    # * Rational values became floating point;
    # * {Measure} and {Geo::Coord} became hashes;
    # * other entities became: when loaded - hashes, when not loaded -
    #    just strings of entity name
    #
    # Example:
    #
    # ```ruby
    # argentina = Reality::Entity('Argentina')
    # # => #<Reality::Entity(Argentina):country>
    # argentina.head_of_government.load!
    # # => #<Reality::Entity(Mauricio Macri)>
    # agentina.to_h
    # # {:name=>"Argentina",
    # # :long_name=>"Argentine Republic",
    # # :area=>{:amount=>2780400.0, :unit=>"km²"},
    # # :gdp_ppp=>{:amount=>964279000000.0, :unit=>"$"},
    # # :population=>{:amount=>43417000.0, :unit=>"person"},
    # # :head_of_government=>
    # #   {:name=>"Mauricio Macri",
    # #   :birthday=>"1959-02-08",
    # #   ....},
    # # :country=>"Argentina",
    # # :continent=>"South America",
    # # :head_of_state=>"Mauricio Macri",
    # # :capital=>"Buenos Aires",
    # # :currency=>"peso",
    # # :neighbours=>["Uruguay", "Brazil", "Chile", "Paraguay", "Bolivia"],
    # # :tld=>".ar",
    # # :adm_divisions=>["Buenos Aires", "Buenos Aires Province", ....],
    # # :iso2_code=>"AR",
    # # :iso3_code=>"ARG",
    # # :part_of=>["Latin America"],
    # # :tz_offset=>"-03:00",
    # # :organizations=>["United Nations","Union of South American Nations","Mercosur",...],
    # # :calling_code=>"+54",
    # # :created_at=>"1816-01-01",
    # # :highest_point=>"Aconcagua",
    # # :coord=>{:lat=>-34.0, :lng=>-64.0},
    # # :official_website=>"http://www.argentina.gob.ar/",
    # # :gdp_nominal=>{:amount=>537659972702.0, :unit=>"$"}}
    # #
    # ```
    #
    # @return [Hash]
    def to_h
      load! unless loaded?
      {name: name}.merge \
        values.map{|k, v| [k.to_sym, Coercion.to_simple_type(v)]}.to_h
    end

    # Converts entity to JSON (same as `entity.to_h.to_json`)
    #
    # @see #to_h
    # @return [String]
    def to_json
      to_h.to_json
    end

    protected

    def after_load
      @wikipage and @values.update(Definitions::MediaWiki.parse(@wikipage))
      @wikidata and @values.update(Definitions::Wikidata.parse(@wikidata))
      (@values.keys - methods).each do |sym|
        define_singleton_method(sym){@values[sym]}
      end
      Modules.include_into(self)
    end

    def _describe
      load! unless loaded?
      Util::Format.describe(inspect, values.map{|k,v| [k, v.inspect]})
    end
  end
end
