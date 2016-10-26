require 'tz_offset'

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
          num = Util::Parse.scaled_number(val.to_s)
          if u == 'km²' && num > 1_000_000 && (num % 1_000_000).zero?
            # Wikidata now sometimes provide area in square meters.
            # As we still can't extract units via SPARQL, here is ugly hack!
            num /= 1_000_000
          end
          Measure.coerce(num, u)
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
          val.map{|row| coerce(row, type.first, **opts.except(:parse))}.
              derp{|arr| arr.all?{|e| e.is_a?(Entity)} ? List.new(*arr) : arr}
        when Symbol
          parser = COERCERS[type] or fail("No coercion to #{type.inspect}")
          parser.call(val, **opts)
        else
          fail("No parser for type #{type.inspect}")
        end
      end

      def to_simple_type(val)
        case val
        when Rational
          val.to_f
        when nil, Numeric, String, Symbol
          val
        when Array
          val.map{|v| to_simple_type(v)}
        #when Hash
          #val.map{|k, v| [to_simple_type(k), to_simple_type(v)]}.to_h
        when Entity
          val.loaded? ? val.to_h : val.to_s

        when ->(v){v.respond_to?(:to_h)}
          val.to_h
        else
          val.to_s
        end
      end

    end
  end
end
