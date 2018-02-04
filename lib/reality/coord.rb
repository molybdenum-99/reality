module Reality
  class Coord < Geo::Coord
    def timezone
      Util.require_optional('wheretz', 'Please install `wheretz` gem in order to have offline timezones')
      WhereTZ.get(lat, lng)
    end

    def distance(other)
      other = coerce_to_coord(other)
      Reality::Measure['km'].new(super(other) / 1000.0)
    end

    private

    def coerce_to_coord(val)
      case val
      when Geo::Coord
        other
      when Entity
        (val['coordinates'] || val['coordinates location'])&.value or
          fail ArgumentError, "#{val} seem not hold any coordinates information"
      else
        fail ArgumentError, "#{val.class} can't be coerced to coordinates"
      end
    end
  end
end
