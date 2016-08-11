module Reality::Definitions
  # @private
  module Wikidata
    module_function

    def define(&block)
      instance_eval(&block)
    end

    def parse(wikidata)
      wikidata.predicates.map{|key, val|
        [val, definitions[key]]
      }.reject{|_, dfn| !dfn}.
      map{|val, (symbol, type, opts)|
        [symbol, Reality::Entity::Coercion.coerce(val, type, **opts)]
      }.to_h
    end

    private
    module_function

    def predicate(pred, symbol, type, **opts)
      definitions[pred] = [symbol, type, opts]
    end

    def definitions
      @definitions ||= {}
    end
  end

  Reality.require_ %w[definitions/wikidata/*]
end
