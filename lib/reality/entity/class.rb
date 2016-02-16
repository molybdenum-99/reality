module Reality
  module EntityClass
    def by_infobox(*infobox_names)
      infobox_names.each do |n|
        EntityClass.classes_by_infobox[n] = self
      end
    end

    def properties
      @properties ||= {}
    end
    
    def property(name, **opts)
      opts[:type] ||= :string
      properties[name] = opts
    end

    def extended(entity)
      properties.each do |n, **opts|
        entity.define_singleton_method(n){values[n] ||= fetch(**opts)}
      end
      props = properties
      entity.define_singleton_method(:properties){props}
    end

    class << self
      def classes_by_infobox
        @classes_by_infobox ||= {}
      end

      def for(entity)
        classes_by_infobox[entity.wikipage.infobox.name]
      end
    end
  end
end
