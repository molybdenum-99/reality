require 'timezone'
require 'tzinfo'

module Reality
  module Extras
    module Geonames
      module CoordTimezone
        def timezone
          @timezone ||= guess_timezone
        end

        private
        
        def guess_timezone
          Timezone::Configure.username = Reality.config.fetch('keys', 'geonames')
          
          gnzone = Timezone::Zone.new(latlon: [lat.to_f, lng.to_f])
          gnzone && TZInfo::Timezone.new(gnzone.zone)
        end
      end

      def self.included(reality)
        reality.config.register('keys', 'geonames',
          desc: 'GeoNames username. Can be received from http://www.geonames.org/login')
        reality::Geo::Coord.include CoordTimezone
      end
    end
  end
end
