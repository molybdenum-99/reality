module Reality::Definitions
  # @private
  module MediaWiki
    module_function

    def define(&block)
      instance_eval(&block)
    end

    def clear
      definitions.clear
      parsers.clear
    end

    def parse(wikipage)
      return {} if @disabled

      from_templates =
        definitions.map{|name, symbol, type, infobox_names, opts|
          infobox_names.map { |infobox_name|
            infobox = wikipage.templates(name: infobox_name).first
            var = infobox && infobox.fetch(name)
            if var && !var.empty?
              [symbol, Reality::Entity::Coercion.coerce(var, type, **opts)]
            end
          }
        }.flatten(1).compact.to_h
      from_parsers =
        parsers.map { | symbol, type, opts, parser|
          val = parser.call(wikipage)
          if val
            [symbol, Reality::Entity::Coercion.coerce(val, type, **opts)]
          end
        }.compact.to_h

      from_templates.merge(from_parsers)
    end

    def disable!
      @disabled = true
    end

    def enable!
      @disabled = false
    end

    private
    module_function

    def infobox_field(name, symbol, type, infobox: @current_infobox, **opts)
      infobox or fail ArgumentError, "You need to define template name or pattern to look for field #{name}"
      definitions << [name, symbol, type, [*infobox], opts]
    end

    def infobox(*names)
      @current_infobox = names
      yield
      @current_infobox = nil
    end

    def definitions
      @definitions ||= []
    end

    def parsers
      @parsers ||= []
    end

    def parser(symbol, type, **opts, &block)
      parsers << [symbol, type, opts, block]
    end
  end
end
