module Reality
  class List < Array
    using Refinements
    
    def initialize(*names)
      super names.map(&method(:coerce))
    end

    def load!
      partition(&:wikidata_id).tap{|wd, wp|
          load_by_wikipedia(wp)
          load_by_wikidata(wd)
        }
      self
    end

    [:select, :reject, :sort, :sort_by,
    :compact, :-, :map, :first, :last, :sample, :shuffle].each do |sym|
      define_method(sym){|*args, &block|
        ensure_type super(*args, &block)
      }
    end

    def inspect
      "#<#{self.class.name}[#{map(&:to_s?).join(', ')}]>"
    end

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
        fetch_list(*pages.values.compact.map(&:title))

      entities.each do |entity|
        page = pages[entity.name]
        data = page && datum[page.title]
        entity.setup!(wikipage: page, wikidata: data)
      end
    end

    def load_by_wikidata(entities)
      return if entities.empty?
      
      datum = Wikidata::Entity.
        fetch_list_by_id(*entities.map(&:wikidata_id))
      pages = Infoboxer.wp.
        get_h(*datum.values.compact.map(&:en_wikipage).compact)
      entities.each do |entity|
        data = datum[entity.wikidata_id]
        page = data && pages[data.en_wikipage]
        entity.setup!(wikipage: page, wikidata: data)
      end
    end

    def ensure_type(arr)
      if arr.kind_of?(Array) && arr.all?{|e| e.is_a?(Entity)}
        List[*arr]
      else
        arr
      end
    end

    def coerce(val)
      case val
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
