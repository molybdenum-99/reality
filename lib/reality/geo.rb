module Reality
  module Geo
    # GeoKit, RGeo, GeoRuby -- I know, ok?
    # It's just incredibly simple class to hold two values
    # and show them prettily.
    #
    # GeoKit will be used at its time.
    class Point
      attr_reader :lat, :lng

      alias_method :latitude, :lat
      alias_method :longitude, :lng

      class << self
        def from_dms(lat, lng)
          new(decimal_from_dms(lat), decimal_from_dms(lng))
        end

        private

        DIRS = {
          'N' => +1,
          'S' => -1,
          'E' => +1,
          'W' => -1
        }

        def parse_direction(dir)
          DIRS[dir] or fail("Undefined coordinates direction: #{dir.inspect}")
        end

        def decimal_from_dms(dms)
          sign = if dms.last.is_a?(String)
            parse_direction(dms.pop)
          else
            dms.first.to_i <=> 0
          end
          
          d, m, s = *dms
          sign * (d.abs.to_i + m.to_f / 60 + s.to_f / 3600)
        end
      end
      
      def initialize(lat, lng)
        @lat, @lng = Rational(lat.to_f), Rational(lng.to_f)
      end

      def lat_dms(direction = true)
        seconds = (lat.abs % 1.0) * 3600.0
        d, m, s = lat.to_i, (seconds / 60).to_i, (seconds % 60)
        if direction
          [d.abs, m, s, d >= 0 ? 'N' : 'S']
        else
          [d, m, s]
        end
      end

      def lng_dms(direction = true)
        seconds = (lng.abs % 1.0) * 3600.0
        d, m, s = lng.to_i, (seconds / 60).to_i, (seconds % 60)
        if direction
          [d.abs, m, s, d >= 0 ? 'E' : 'W']
        else
          [d, m, s]
        end
      end

      def ==(other)
        other.is_a?(self.class) && lat == other.lat && lng == self.lng
      end

      def inspect
        "#<#{self.class}(#{lat.to_f},#{lng.to_f})>"
      end
    end
  end
end
