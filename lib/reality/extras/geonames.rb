require 'timezone'
require 'tzinfo'

# FIXME
Timezone::Configure.begin do |c|
  c.username = GEONAMES_USERNAME
end

module Reality
  module Extras
    module Geonames
      module CoordTimezone
        def timezone
          @timezone ||= guess_timezone
        end

        private
        
        def guess_timezone
          gnzone = Timezone::Zone.new(latlon: [lat.to_f, lng.to_f])
          gnzone && TZInfo::Timezone.new(gnzone.zone)
        end
      end

      def self.included(reality)
        reality::Geo::Coord.include CoordTimezone
      end
    end
  end
end
