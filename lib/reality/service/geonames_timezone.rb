require 'reality/tlaw/geonames'
require 'tzinfo'

module Reality
  module Service
    class GeonamesTimezone
      def initialize(entity, username)
        @entity = entity
        @client = TLAW::GeoNames.new(username: username)
      end

      def name
        @client
          .timezone(@entity.coord.lat, @entity.coord.lng)['timezoneId']
          .derp(&TZInfo::Timezone.method(:get))
      end

      def inspect
        "#<#{self.class.name}(#{@entity.name}): #{service_methods.join(', ')}>"
      end

      private

      def service_methods
        methods
          .map(&method(:method))
          .select { |m| m.owner == self.class }
          .map(&:name)
          .derp { |ms| ms - %i[inspect] }
      end
    end
  end
end
