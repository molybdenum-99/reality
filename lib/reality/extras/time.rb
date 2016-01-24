require 'timezone'
Timezone::Configure.begin do |c|
  c.username = GEONAMES_USERNAME
end

module Reality
  class Time
    attr_accessor :timezone

    def initialize(zone: nil, coords: nil)
      if zone
        @timezone = Timezone::Zone.new :zone => zone
      elsif coords
        @timezone = Timezone::Zone.new :latlon => coords
      end
    end

    def local(*args)
      localtime(::Time.utc(*args) - timezone.utc_offset)
    end

    def parse(time_string)
      localtime(::Time.parse(time_string + ' UTC') - timezone.utc_offset)
    end

    def now
      localtime(::Time.now)
    end

    def zone
      timezone.zone
    end

    def inspect
      "#<%s(%s)>" % [self.class, *zone]
    end

    private

    def localtime(time)
      timezone.time_with_offset(time)
    end
  end
  module Extras
    module TimeExtras
      module EntityTime
        def time
          @time ||= Time.new(coords: [coord.lat.to_f, coord.lng.to_f])
        end
      end

      module CityTime
        include EntityTime
      end

      module CountryTime
        include EntityTime

        def time
          @time ||= capital.time
        end
      end

      def self.included(_mod)
        Reality::City.include CityTime
        Reality::Country.include CountryTime
      end
    end
  end
end

Reality.include Reality::Extras::TimeExtras
