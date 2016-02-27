module Reality
  class Entity
    class List < Array
      def initialize(*names)
        super names.map(&method(:coerce))
      end

      def load!
        pages = Infoboxer.wp.get(*map(&:name))
        data = Wikidata::Entity.fetch_list(*pages.map(&:title))
        self.zip(pages).each{|e, p|
          e.instance_variable_set('@wikipage', p)
          if d = data[p.title]
            e.instance_variable_set('@wikidata', d)
          end
          e.send(:after_load)
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
