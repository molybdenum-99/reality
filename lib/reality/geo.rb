require 'geokit'
require 'sun_times'
Geokit::default_units = :kms # TODO: use global settings

module Reality
  module Geo
    # GeoKit, RGeo, GeoRuby -- I know, ok?
    # It's just incredibly simple class to hold two values
    # and show them prettily.
    #
    # GeoKit will be used at its time.
    class Coord
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
          sign * (d.abs.to_i + Rational(m.to_i) / 60 + Rational(s.to_f) / 3600)
        end
      end
      
      def initialize(lat, lng)
        @lat, @lng = Rational(lat), Rational(lng)
      end

      def distance_to(point)
        destination_coords = normalize_point(point).to_s
        res = Geokit::LatLng.distance_between(to_s, destination_coords, formula: :sphere)
        Reality::Measure(res, 'km')
      end

      def direction_to(point)
        destination_coords = normalize_point(point).to_s
        res = Geokit::LatLng.heading_between(to_s, destination_coords)
        Reality::Measure(res, '°')
      end

      def endpoint(direction, distance)
        res = Geokit::LatLng.endpoint(to_s, direction.to_f, distance.to_f)
        Coord.new res.lat, res.lng
      end

      def close_to?(point, radius)
        area = Geokit::Bounds.from_point_and_radius(to_s, radius.to_f)
        area.contains?(normalize_point(point).to_s)
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

      def to_s
        "#{lat.to_f},#{lng.to_f}"
      end

      def ==(other)
        other.is_a?(self.class) && lat == other.lat && lng == self.lng
      end

      def inspect
        "#<%s(%i°%i′%i″%s,%i°%i′%i″%s)>" % [self.class, *lat_dms, *lng_dms]
      end

      def sunrise(date = Date.today)
        SunTimes.new.rise(date, lat.to_f, lng.to_f)
      end

      def sunset(date = Date.today)
        SunTimes.new.set(date, lat.to_f, lng.to_f)
      end

      private

      def normalize_point(point)
        return point if point.is_a?(Coord)
        point.coord if point.respond_to?(:coord)
      end
    end
  end
end
