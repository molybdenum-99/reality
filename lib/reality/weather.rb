require 'open_weather'

module Reality
  module Weather
    def pressure
      current_weather['main']['pressure']
    end

    def humidity
      current_weather['main']['humidity']
    end

    def temperature
      current_weather['main']['temp']
    end

    def weather
      current_weather['weather'][0]['main']
    end

    private

    def current_weather
      return @weather if @weather
      res = OpenWeather::Current.new(weather_options).retrive
      if res.is_a?(Hash)
        @weather = res
      else
        fail(res.inspect)
      end
    end

    def weather_options
      raise NotImplementedError
    end
  end

  class Country
    include Weather

    def weather_options
      {country: name, :APPID => '90d73c1188829195d023b5a5fc6399e1'}
    end
  end
end
