module Reality
  class Entity
    module Coercion
      using Refinements
      
      COERCERS = {
        entity: ->(val, **opts){
          case val
          when Wikidata::Link
            Entity.new(val.label || val.id, wikidata_id: val.id)
          when Infoboxer::Tree::Wikilink
            Entity.new(val.link)
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
        tz_offset: ->(val, **opts){
          TZOffset.parse(val.to_s)
        },
        coord: -> (val, **opts){
          val.is_a?(Geo::Coord) ? val : nil
        },
        date: ->(val, **opts){
          case val
          when DateTime
            # FIXME: in future, parse strings?..
            val.to_date
          when Date
            val
          else
            nil
          end
        },
        datetime: -> (val, **opts){
          val.is_a?(DateTime) ? val : nil # FIXME: in future, parse strings?..
        },
      }

      module_function

      def coerce(val, type, **opts)
        if val.kind_of?(Array) && !type.kind_of?(Array)
          val = val.first
        end

        if opts[:parse]
          val = opts[:parse].call(val)
        end

        return nil if val.nil?

        # FIXME: better errors: including field name & class name
        case type
        when Array
          type.count == 1 or fail("Only homogenous array types supported, #{type.inspect} received")
          val.kind_of?(Array) or fail("Array type expected, #{val.inspect} received")
          val.map{|row| coerce(row, type.first, **opts)}.
              derp{|arr| arr.all?{|e| e.is_a?(Entity)} ? Entity::List.new(*arr) : arr}
        when Symbol
          parser = COERCERS[type] or fail("No coercion to #{type.inspect}")
          parser.call(val, **opts)
        else
          fail("No parser for type #{type.inspect}")
        end
      end

    end
  end
end
