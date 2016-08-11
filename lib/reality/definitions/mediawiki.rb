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

      [parse_templates(wikipage), parse_free_parsers(wikipage)].inject(:merge)
    end

    def disable!
      @disabled = true
    end

    def enable!
      @disabled = false
    end

    private
    module_function

    def parse_templates(wikipage)
      definitions.map{|name, symbol, type, infobox_names, opts|
        infobox_names.map { |infobox_name|
          infobox = wikipage.templates(name: infobox_name).first
          make_key_value(infobox && infobox.fetch(name), symbol, type, opts)
        }
      }.flatten(1).compact.to_h
    end

    def parse_free_parsers(wikipage)
      parsers.map { | symbol, type, opts, parser|
        make_key_value(parser.call(wikipage), symbol, type, opts)
      }.compact.to_h
    end

    def make_key_value(value, symbol, type, opts)
      if value && !(value.respond_to?(:empty?) && value.empty?)
        [symbol, Reality::Entity::Coercion.coerce(value, type, **opts)]
      end
    end

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
