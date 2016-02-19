module Reality
  class Entity
    module WikidataProperties
      module_function

      PARSERS = {
        entity: ->(val, **opts){
          case val
          when Wikidata::Link
            Entity.new(val.label || val.id)
          else
            fail ArgumentError, "Can't coerce #{val.inspect} to Entity"
          end
        },
        measure: ->(val, **opts){
          u = opts[:unit] || opts[:units] or fail("Units are not defined for measure type")
          Measure.coerce(Util::Parse.number(val.to_s), u)
        },
        string: ->(val, **opts){
          val.to_s
        },
        utc_offset: ->(val, **opts){
          val.to_s.sub(/^UTC/, '').tr('−', '-').to_i # FIXME: definitely too naive
        },
        coord: -> (val, **opts){
          val.is_a?(Geo::Coord) ? val : nil
        }
      }
      
      def define(&block)
        instance_eval(&block)
      end

      def parse(wikidata)
        wikidata.predicates.map{|key, val|
          [val, definitions[key]]
        }.reject{|_, dfn| !dfn}.
        map{|val, (symbol, type, opts)|
          [symbol, coerce_value(val, type, **opts)]
        }.to_h
      end

      private
      module_function

      def property(predicate, symbol, type, **opts)
        definitions[predicate] = [symbol, type, opts]
      end

      def definitions
        @definitions ||= {}
      end

      def coerce_value(val, type, **opts)
        if val.kind_of?(Array) && !type.kind_of?(Array)
          val = val.first
        end

        case type
        when Array
          type.count == 1 or fail("Only homogenous array types supported, #{type.inspect} received")
          val.kind_of?(Array) or fail("Array type expected, #{val.inspect} received")
          val.map{|row| coerce_value(row, type.first, **opts)}
        when Symbol
          parser = PARSERS[type] or fail("No parser for type #{type.inspect}")
          parser.call(val, **opts)
        else
          fail("No parser for type #{type.inspect}")
        end
      end
    end
  end
end
