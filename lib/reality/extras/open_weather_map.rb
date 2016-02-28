require 'open_weather'

module Reality
  module Extras
    module OpenWeatherMap
      class Weather < Hashie::Mash
        def temp
          temperature
        end
        
        def to_h
          to_hash(symbolize_keys: true)
        end

        def inspect
          "#<Reality::Weather(%s)>" %
            [temperature, sky].map(&:to_s).reject(&:empty?).join(', ')
        end
        
        class << self
          def from_hash(hash)
            hash = hash.dup.extend Hashie::Extensions::DeepFetch
            new(
                humidity: fetch(hash, 'main', 'humidity', '%'),
                sky: hash.deep_fetch('weather', 0, 'main'),
                temperature: fetch(hash, 'main', 'temp', '°C'),
                pressure: fetch(hash, 'main', 'pressure', 'Pa')
             )
          end

          private

          def fetch(hash, *path, unit)
            Reality::Measure.new(hash.deep_fetch(*path), unit)
          rescue Hashie::Extensions::DeepFetch::UndefinedPathError, KeyError
            nil
          end
        end
      end

      module CoordWeather
        def weather
          res = OpenWeather::Current.geocode(lat.to_f, lng.to_f,
                        units: 'metric', APPID: appid) 

          Weather.from_hash(res)
        end

        private

        def appid
          Reality.config.fetch('keys', 'open_weather_map')
        end
      end

      def self.included(reality)
        reality.config.register('keys', 'open_weather_map',
          desc: 'OpenWeatherMap APPID. Can be obtained here: http://openweathermap.org/appid')
        reality::Geo::Coord.include CoordWeather
      end
    end
  end
end
