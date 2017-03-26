require 'tlaw'

module Reality
  module DataSources
    class OpenWeatherMap
      def initialize(key)
        @api = API.new(appid: key, units: :metric)
      end

      MAPPING = {
        'main.temp' => [:temperature, Measure['°C'].method(:new)]
      }.freeze

      IDENTITY = :itself.to_proc

      def find(lat_lng, at: nil)
        at ? forecast(*lat_lng, at) : current(*lat_lng)
      end

      private

      def current(lat, lng)
        @api.current(lat, lng).derp { |response|
          [
            parse_source(response),
            *map_values(response).compact.map { |name, val| Observation.new(name, val) }
          ]
        }
      end

      def forecast(lat, lng, timestamp)
        # TODO: return [] unless (0..5).cover?(TimeMath.day.diff(Time.now, timestamp))

        @api.forecast(lat, lng).derp { |response|
          [
            parse_source(response),
            *response['list'].flat_map { |row|
              map_values(row).map { |name, value|
                Observation.new(name, value, time: Time.at(row['dt']))
              }
            }
          ]
        }
      end

      def map_values(data)
        MAPPING.map { |field, (name, conv)|
          conv ||= IDENTITY
          data[field].derp { |val| val && [name, conv.call(val)] }
        }
      end

      def parse_source(response)
        response['coord'].derp { |coord|
          Observation.new(:_source, Link.new(:open_weather_map, "#{coord.lat},#{coord.lng}"))
        }
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
              e['coord'] = Geo::Coord.new(e['coord.lat'], e['coord.lon']) if e['coord.lat'] && e['coord.lon']
            }
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
