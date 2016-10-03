require 'reality/tlaw/open_weather_map'
require 'reality/observation'
require 'reality/observations'

module Reality
  module Service
    class OpenWeatherMap
      def initialize(entity, appid)
        @entity = entity
        @client = TLAW::OpenWeatherMap.new(appid: appid, units: :metric)
      end

      # description "Weather through OpenWeatherMap"
      #
      # config_key 'open_weather_map'
      # condition(&:coord)
      # method_name :weather # TODO: `, :osm` and switch services

      def current
        @client.current
          .location(@entity.coord.lat, @entity.coord.lng)
          .derp { |hash| remap(hash, WEATHER_MAPPINGS).merge(_type: 'Weather') }
          .derp(&Observation.method(:new)) # TODO: Observation['Weather'].method(:new) here
      end

      def forecast
        @client.forecast
          .location(@entity.coord.lat, @entity.coord.lng)['list']
          .map { |row| remap(row, WEATHER_MAPPINGS).merge(_type: 'Weather') }
          .derp(&Observations.method(:from_hashes)) # TODO: Observations['Weather'].method(:new) here
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

      WEATHER_MAPPINGS = {
        'dt' => :_index,
        'main.temp' => :temp,
        'main.temp_min' => :temp_min,
        'main.temp_max' => :temp_max,
        'main.humidity' => :humidity,
        'main.pressure' => :pressure,
      }

      def remap(hash, mappings)
        hash.map { |key, val|
          [mappings[key], val]
        }.reject { |k, *| k.nil? }.to_h
      end
    end
  end
end
