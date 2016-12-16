module Reality
  # List is subclass of Array, which allows effective entities storing
  # and loading.
  #
  # You can create list from entities or just their names:
  #
  # ```ruby
  # Reality::List.new('Argentina', 'Ukraine')
  # # => #<Reality::List[Argentina?, Ukraine?]>
  # ```
  #
  # ...or from existing entities:
  #
  # ```ruby
  # Reality::List.new(Reality::Entity.new('Argentina'), Reality::Entity.new('Ukraine'))
  # # => #<Reality::List[Argentina?, Ukraine?]>
  # ```
  #
  # List is useful for compact inspect (see above), and for effective
  # batch loading (see {#load!}).
  #
  # Also, List is smart enough to remain List on multiple enumerable
  # methods like `#select`, `#reject`, `#map` and so on:
  #
  # ```ruby
  # Reality::List.new('Argentina', 'Bolivia', 'Chile').sample(2)
  # # => #<Reality::List[Chile?, Argentina?]>
  #
  # Reality::List.new('Argentina', 'Bolivia', 'Chile').load!.map(&:capital)
  # # => #<Reality::List[Buenos Aires?, La Paz?, Santiago?]>
  # ```
  #
  class List < Array
    using Refinements

    # Creates List from a set of entity names or entity objects.
    # Also aliased as `Reality::List()` method.
    #
    def initialize(*names)
      super names.map(&method(:coerce))
    end

    # Loads all entities in batch. Optimized to make as few requests
    # as possible. Typically, when you want to load several entities
    #
    # @return [self]
    def load!(frame = 3)
      Timeout.timeout(frame) do
        compact.partition(&:wikidata_id).tap{|wd, wp|
            load_by_wikipedia(wp)
            load_by_wikidata(wd)
          }
        # try to fallback to labels:
        compact.reject(&:loaded?).tap{|entities|
          load_by_wikidata_labels(entities)
        }
      end

      self
    end

    [:select, :reject, :sort, :sort_by,
    :compact, :-, :map, :first, :last, :sample, :shuffle].each do |sym|
      define_method(sym){|*args, &block|
        ensure_type super(*args, &block)
      }
    end

    # @return [String]
    def inspect
      "#<#{self.class.name}[#{map{|e| e ? e.to_s? : e.inspect}.join(', ')}]>"
    end

    # Prints compact description of the list. Implicitly loads all list
    # if not loaded.
    #
    # ```ruby
    # Reality::List.new('Argentina', 'Bolivia', 'Chile').describe
    # # -------------------------
    # # #<Reality::List(3 items)>
    # # -------------------------
    # #   keys: adm_divisions (3), area (3), calling_code (3), capital (3), continent (3), coord (3), country (3), created_at (3), currency (3), gdp_nominal (3), gdp_ppp (3), head_of_government (2), head_of_state (3), highest_point (3), iso2_code (3), iso3_code (3), long_name (3), neighbours (3), official_website (1), organizations (3), part_of (3), population (3), tld (3), tz_offset (3)
    # #  types: country (3)
    # ```
    #
    # @return [nil]
    def describe
      load! unless all?(&:loaded?)
      
      meta = {
        types: map(&:wikipedia_type).compact.map(&:symbol).
          group_count.sort_by(&:first).map{|t,c| "#{t} (#{c})"}.join(', '),
         keys: map(&:values).map(&:keys).flatten.
          group_count.sort_by(&:first).map{|k,c| "#{k} (#{c})"}.join(', '),
      }
      # hard to read, yet informative version:
      #keys = map(&:values).map(&:to_a).flatten(1).
            #group_by(&:first).map{|key, vals|
              #values = vals.map(&:last)
              #[key, "(#{values.compact.count}) example: #{values.compact.first.inspect}"]
            #}.to_h
      puts Util::Format.describe("#<#{self.class.name}(#{count} items)>", meta)
    end

    private

    def load_by_wikipedia(entities)
      return if entities.empty?
      
      pages = Infoboxer.wp.get_h(*entities.map(&:name))
      datum = Wikidata::Entity.
        by_wikititle(*pages.values.compact.map(&:title))

      entities.each do |entity|
        page = pages[entity.name]
        data = page && datum[page.title]
        entity.setup!(wikipage: page, wikidata: data)
      end
    end

    def load_by_wikidata(entities)
      return if entities.empty?
      
      datum = Wikidata::Entity.
        by_id(*entities.map(&:wikidata_id))
      pages = Infoboxer.wp.
        get_h(*datum.values.compact.map(&:en_wikipage).compact)
      entities.each do |entity|
        data = datum[entity.wikidata_id]
        page = data && pages[data.en_wikipage]
        entity.setup!(wikipage: page, wikidata: data)
      end
    end

    def load_by_wikidata_labels(entities)
      return if entities.empty?
      
      datum = Wikidata::Entity.
        by_label(*entities.map(&:name))
      entities.each do |entity|
        data = datum[entity.name]
        entity.setup!(wikidata: data)
      end
    end

    def ensure_type(arr)
      if arr.kind_of?(Array) && arr.all?{|e| e.nil? || e.is_a?(Entity)}
        List[*arr]
      else
        arr
      end
    end

    def coerce(val)
      case val
      when nil
        val
      when String
        Entity.new(val)
      when Entity
        val
      else
        fail ArgumentError, "Can't coerce #{val.inspect} to Entity"
      end
    end
  end
end
