module Reality
  class Entity
    module WikipediaType
      def infobox_name(*infobox_names)
        infobox_names.each do |n|
          WikipediaType.types_by_infobox[n] = self
        end
      end

      def infobox(name, symbol, type, **opts)
        infobox_fields[name] = [symbol, type, opts]
      end

      def extended(entity)
        return unless entity.is_a? Entity
        return if !entity.wikipage || !entity.wikipage.infobox
        
        values = infobox_fields.map{|name, (symbol, type, opts)|
          [symbol, Entity::Coercion.coerce(entity.wikipage.infobox.fetch(name), type, **opts)]
        }.reject{|k, v| !v}.to_h
        
        entity.values.update(values){|k, o, n| o || n} # Don't rewrite already fetched from WP
      end

      def symbol
        # FIXME: to core ext
        self.name.
          gsub(/^.+::/, '').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          downcase.
          to_sym
      end

      private

      def infobox_fields
        @infobox_fields ||= {}
      end

      class << self
        def types_by_infobox
          # TODO: should be Hashie::Rash, in fact, for supporting Regexp keys
          @types_by_infobox ||= {}
        end

        def for(entity)
          types_by_infobox[entity.wikipage.infobox.name]
        end
      end
    end
  end
end
