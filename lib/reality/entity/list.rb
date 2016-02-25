module Reality
  class Entity
    class List < Array
      def initialize(*names)
        super names.map(&method(:coerce))
      end

      def load!
        pages = Infoboxer.wp.get(*map(&:name))
        data = Wikidata::Entity.fetch_list(*pages.map(&:title))
        self.zip(pages, data).each{|e, p, d|
          e.instance_variable_set('@wikipage', p)
          e.instance_variable_set('@wikidata', d)
          e.send(:after_load)
        }
        self
      end

      #def count
        #@names.count
      #end

      #def all
        #[*Infoboxer.wikipedia.get(*names)].
          #zip(names).map{|page, name|
            #Entity.new(name, wikipage: page, wikidata: Wikidata::Entity.fetch(page.title))
          #}
      #end

      [:select, :reject, :sort_by, :flatten, :compact, :-, :map, :first, :last].each do |sym|
        define_method(sym){|*args, &block|
          ensure_type super(*args, &block)
        }
      end

      private

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
end
