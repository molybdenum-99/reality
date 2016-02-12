module Reality
  module EntityProperties
    using Refinements
    
    def fetch(**opts)
      if opts[:wikidata]
        coerce(opts[:type], wikidata[opts[:wikidata]], **opts.except(:type, :wikidata))
      elsif opts[:wikipedia]
        coerce(opts[:type], wikipage.infobox.fetch(opts[:wikipedia]), **opts.except(:type, :wikipedia))
      else
        fail "Can't fetch anything except wikidata and wikipedia, sorry!"
      end
    end

    protected

    def coerce(type, data, **opts)
      if data.kind_of?(Array) && !type.kind_of?(Array)
        data = data.first
      end

      if opts[:parse]
        data = opts[:parse].call(data)
      end

      # FIXME: better errors: including field name & class name
      case type
      when Array
        type.count == 1 or fail("Only homogenous array types supported, #{type.inspect} received")
        data.kind_of?(Array) or fail("Array type expected, #{data.inspect} received")
        data.map{|row| coerce(type.first, row, **opts)}
      when :entity
        coerce_entity(data)
      when :measure
        u = opts[:unit] || opts[:units] or fail("Units are not defined for measure type")
        Measure.coerce(Util::Parse.number(data.to_s), u)
      when :string, nil
        data.to_s
      when :utc_offset
        data.to_s.sub(/^UTC/, '').tr('−', '-').to_i # FIXME: definitely too naive
      when :coord
        data.is_a?(Geo::Coord) ? data : nil
      else
        fail ArgumentError, "Can't coerce #{data.inspect} to #{type.inspect}"
      end
    end

    def coerce_entity(obj)
      case obj
      when Wikidata::Link
        Entity.new(obj.label || obj.id)
      else
        fail ArgumentError, "Can't coerce #{obj.inspect} to Entity"
      end
    end
  end
end
