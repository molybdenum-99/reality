module Reality
  class Entity
    # @private
    module WikipediaType
      def infobox_name(*infobox_names)
        infobox_names.each do |n|
          WikipediaType.types_by_infobox[n] = self
        end
      end

      def infobox(name, symbol, type, **opts)
        infobox_fields[name] = [symbol, type, opts]
      end

      def parse(symbol, type, **opts, &parser)
        page_parsers << [symbol, type, opts, parser]
      end

      def extended(entity)
        return unless entity.is_a? Entity
        return if !entity.wikipage || !entity.wikipage.infobox
        
        values = infobox_fields.map{|name, (symbol, type, opts)|
          var = entity.wikipage.infobox.fetch(name)
          if var.empty?
            [symbol, nil]
          else
            [symbol, Entity::Coercion.coerce(var, type, **opts)]
          end
        }.reject{|k, v| !v}.to_h

        parsed = page_parsers.map{|symbol, type, opts, parser|
          [symbol, Entity::Coercion.coerce(parser.call(entity.wikipage), type, **opts)]
        }.reject{|k, v| !v}.to_h
        
        entity.values.update(values){|k, o, n| o || n} # Don't rewrite already fetched from WP
        entity.values.update(parsed){|k, o, n| o || n} # Don't rewrite already fetched from WP or infobox
      end

      def symbol
        return nil unless name
        # FIXME: to core ext
        name.
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

      def page_parsers
        @page_parsers ||= []
      end

      class << self
        def types_by_infobox
          # TODO: should be Hashie::Rash, in fact, for supporting Regexp keys
          @types_by_infobox ||= {}
        end

        def for(entity)
          entity.wikipage.infobox &&
            types_by_infobox[entity.wikipage.infobox.name]
        end
      end
    end
  end
end
