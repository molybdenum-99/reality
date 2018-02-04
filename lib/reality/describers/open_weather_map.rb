require 'tlaw'

module Reality
  module Describers
    class OpenWeatherMap < Abstract::Base
      def initialize(key)
        @api = API.new(appid: key, units: :metric)
      end

      DROP = %[weather.id sys.id sys.type sys.message cod base].freeze
      RENAME = {'weather.main' => 'weather', 'dt' => 'timestamp'}.freeze

      CONVERT = {
        'temp' => Measure['°C'],
        'temp_min' => Measure['°C'],
        'temp_max' => Measure['°C'],

        'pressure' => Measure['hPa'],
        'humidity' => Measure['%'],

        'wind_speed' => Measure['m/s'],
        'wind_deg' => Measure['°'],
      }.freeze

      def perform_query(params)
        at = params.delete('at')
        lat, lng = case at
        when Array
          at
        when Geo::Coord
          at.lat_lng
        when Entity
          (at['coordinates'] || at['coordinate location'])&.value&.latlng
        when /^\d+(?:\.\d+)?[,\| ;]\d+(?:\.\d+)?$/
          at.split(/[,\| ;]/).map(&:to_f)
        end

        @api.current(lat, lng).yield_self { |response|
          eid = response.delete('id')
          response.reject { |key, _| DROP.include?(key) }
            .transform_keys { |key| RENAME.fetch(key, key.sub(/^(main|sys)\./, '').sub('.', '_')) }
            .map { |key, value|
              converter = CONVERT.fetch(key, :itself).to_proc
              obs(eid, key, converter.(value))
            }
        }.yield_self(&method(:make_entities))
      end

      private

      def prefix
        'openweathermap'
      end

      class API < TLAW::API
        define do
          base 'http://api.openweathermap.org/data/2.5'

          param :appid, required: true
          param :lang, default: 'en'
          param :units, enum: %i[standard metric imperial], default: :metric

          endpoint :current, '/weather?lat={lat}&lon={lng}' do
            param :lat, :to_f, required: true, desc: 'Latitude'
            param :lng, :to_f, required: true, desc: 'Longitude'

            post_process { |e|
              e['coord'] = Geo::Coord.new(e.delete('coord.lat'), e.delete('coord.lon')) if e['coord.lat'] && e['coord.lon']
            }
            post_process 'dt', &Time.method(:at)
            post_process 'sys.sunrise', &Time.method(:at)
            post_process 'sys.sunset', &Time.method(:at)
          end

          endpoint :forecast, '/forecast?lat={lat}&lon={lng}' do
            param :lat, :to_f, required: true, desc: 'Latitude'
            param :lng, :to_f, required: true, desc: 'Longitude'

            post_process { |e|
              e['coord'] = Geo::Coord.new(e['city.coord.lat'], e['city.coord.lon']) if e['city.coord.lat'] && e['city.coord.lon']
            }
          end
        end
      end

    end
  end
end

Reality.describers['openweathermap'] = Reality.describers['open_weather_map'] = Reality::Describers::OpenWeatherMap.new(ENV['OPEN_WEATHER_MAP_APPID'])
