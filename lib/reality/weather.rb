require 'open_weather'

module Reality
  class Weather < Hashie::Mash; end

  module OpenWeatherMap
    module EntityWeather
      def weather
        return @weather if @weather
        hash = { humidity: fetch_value([:main, :humidity], '%'),
                 description: fetch_value([:weather, 0, :main]),
                 temperature: fetch_value([:main, :temp], '°C'),
                 pressure: fetch_value([:main, :pressure], 'Pa'),
               }

        @weather = Weather.new hash
      end

      private

      def fetch_value(path, unit=nil)
        value = current_weather.deep_fetch(*path.map(&:to_s))
        return value unless unit
        Reality::Measure(value, unit)
      rescue Hashie::Extensions::DeepFetch::UndefinedPathError, KeyError
        'unknown'
      end

      def current_weather
        return @api_response if @api_response
        res = OpenWeather::Current.new(weather_params).retrive
        if res.is_a?(Hash)
          res.extend Hashie::Extensions::DeepFetch
          @api_response = res
        else
          fail(res.inspect)
        end
      end
    end

    module CountryWeather
      include EntityWeather

      def weather_params
        {country: name, :APPID => OPEN_WEATHER_MAP_KEY, units: "metric"}
      end
    end

    def self.included(_mod)
      Reality::Country.include CountryWeather
    end
  end
end

Reality.include Reality::OpenWeatherMap
