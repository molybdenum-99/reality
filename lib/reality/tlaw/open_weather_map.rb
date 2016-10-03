require 'tlaw'

module Reality
  module TLAW
    class OpenWeatherMap < ::TLAW::API
      define do
        desc %Q{
          API for [OpenWeatherMap](http://openweathermap.org/). Only parts
          available for free are implemented (as only them could be tested).
        }

        docs 'http://openweathermap.org/api'

        base 'http://api.openweathermap.org/data/2.5'

        param :appid, required: true,
          desc: 'You need to receive it at http://openweathermap.org/appid (free)'

        param :lang, default: 'en',
          desc: %Q{Language of API responses (affects weather description only).
                   See http://openweathermap.org/current#multi for list of supported languages.}

        param :units, enum: %i[standard metric imperial], default: :standard,
          desc: 'Units for temperature and other values. Standard is Kelvin.'

        namespace :current, '/weather' do
          desc %Q{
            Allows to obtain current weather at one place, designated
            by city, location or zip code.
          }

          docs 'http://openweathermap.org/current'

          endpoint :city, '?q={city}{,country_code}' do
            desc %Q{
              Current weather by city name (with optional country code
              specification).
            }

            docs 'http://openweathermap.org/current#name'

            param :city, required: true, desc: 'City name'
            param :country_code, desc: 'ISO 3166 2-letter country code'
          end

          endpoint :city_id, '?id={city_id}' do
            desc %Q{
              Current weather by city id. Recommended by OpenWeatherMap
              docs.

              List of city ID city.list.json.gz can be downloaded at
              http://bulk.openweathermap.org/sample/
            }

            docs 'http://openweathermap.org/current#cityid'

            param :city_id, required: true, desc: 'City ID (as defined by OpenWeatherMap)'
          end

          endpoint :location, '?lat={lat}&lon={lng}' do
            desc %Q{
              Current weather by geographic coordinates.
            }

            docs 'http://openweathermap.org/current#geo'

            param :lat, :to_f, required: true, desc: 'Latitude'
            param :lng, :to_f, required: true, desc: 'Longitude'
          end

          endpoint :zip, '?zip={zip}{,country_code}' do
            desc %Q{
              Current weather by ZIP code (with optional country code
              specification).
            }

            docs 'http://openweathermap.org/current#zip'

            param :zip, required: true, desc: 'ZIP code'
            param :country_code, desc: 'ISO 3166 2-letter country code'
          end

          endpoint :group, '/../group?id={city_ids}' do
            desc %Q{
              Current weather in several cities by their ids.

              List of city ID city.list.json.gz can be downloaded at
              http://bulk.openweathermap.org/sample/
            }

            docs 'http://openweathermap.org/current#cities'

            param :city_ids, :to_a, required: true
          end
        end

        namespace :find do
          desc %Q{
            Allows to find some place (and weather in it) by set of input
            parameters.
          }

          docs 'http://openweathermap.org/current#accuracy'

          endpoint :by_name, '?q={start_with}{,country_code}' do
            desc %Q{
              Looks for cities by beginning of their names.
            }

            docs 'http://openweathermap.org/current#accuracy'

            param :start_with, required: true, desc: 'Beginning of city name'
            param :country_code, desc: 'ISO 3166 2-letter country code'

            param :cnt, :to_i, range: 1..50, default: 10,
              desc: 'Max number of results to return'

            param :accurate, field: :type,
              enum: {true => 'accurate', false => 'like'},
              default: true,
              desc: %Q{Accuracy level of result.
               true returns exact match values (accurate).
               false returns results by searching for that substring (like).
              }
          end

          endpoint :around, '?lat={lat}&lon={lng}' do
            desc %Q{
              Looks for cities around geographical coordinates.
            }

            docs 'http://openweathermap.org/current#cycle'

            param :lat, :to_f, required: true, desc: 'Latitude'
            param :lng, :to_f, required: true, desc: 'Longitude'

            param :cnt, :to_i, range: 1..50, default: 10,
              desc: 'Max number of results to return'

            param :cluster, enum: {true => 'yes', false: 'no'},
              default: true,
              desc: 'Use server clustering of points'
          end

          # Real path is api/bbox/city - not inside /find, but logically
          # we want to place it here
          endpoint :inside, '/../box/city?bbox={lng_left},{lat_bottom},{lng_right},{lat_top},{zoom}' do
            desc %Q{
              Looks for cities inside specified rectangle zone.
            }

            docs 'http://openweathermap.org/current#rectangle'

            param :lat_top, :to_f, required: true, keyword: true
            param :lat_bottom, :to_f, required: true, keyword: true
            param :lng_left, :to_f, required: true, keyword: true
            param :lng_right, :to_f, required: true, keyword: true
            param :zoom, :to_i, default: 10, keyword: true,
              desc: 'Map zoom level.'

            param :cluster, enum: {true => 'yes', false: 'no'},
              default: true,
              desc: 'Use server clustering of points'
          end
        end

        # http://openweathermap.org/forecast5
        namespace :forecast do
          desc %Q{
            Allows to obtain weather forecast for 5 days with 3-hour
            frequency.

            NB: OpenWeatherMap also implement [16-day forecast](http://openweathermap.org/forecast16),
            but it have no free option and can not be tested. That's why
            we don't implement it.
          }

          docs 'http://openweathermap.org/forecast5'

          endpoint :city, '?q={city}{,country_code}' do
            desc %Q{
              Weather forecast by city name (with optional country code
              specification).
            }

            docs 'http://openweathermap.org/forecast5#name5'

            param :city, required: true, desc: 'City name'
            param :country_code, desc: 'ISO 3166 2-letter country code'
          end

          endpoint :city_id, '?id={city_id}' do
            desc %Q{
              Current weather by city id. Recommended by OpenWeatherMap
              docs.

              List of city ID city.list.json.gz can be downloaded at
              http://bulk.openweathermap.org/sample/
            }

            docs 'http://openweathermap.org/forecast5#cityid5'

            param :city_id, required: true, desc: 'City ID (as defined by OpenWeatherMap)'
          end

          endpoint :location, '?lat={lat}&lon={lng}' do
            desc %Q{
              Weather forecast by geographic coordinates.
            }

            docs 'http://openweathermap.org/forecast5#geo5'

            param :lat, :to_f, required: true, desc: 'Latitude'
            param :lng, :to_f, required: true, desc: 'Longitude'
          end

          post_process { |e|
            e['city.coord'] = Geo::Coord.new(e['city.coord.lat'], e['city.coord.lon']) \
              if e['city.coord.lat'] && e['city.coord.lon']
          }
          post_process('city.coord.lat') { nil }
          post_process('city.coord.lon') { nil }
        end

        # OpenWeatherMap reports most of logical errors with HTTP code
        # 200 and responses like {cod: "500", message: "Error message"}
        post_process { |h|
          !h.key?('cod') || (200..400).cover?(h['cod'].to_i) or
            fail "#{h['cod']}: #{h['message']}"
        }

        WEATHER_POST_PROCESSOR = lambda do |*|
          # Most of the time there is exactly one weather item...
          # ...but sometimes there are two. So, flatterning them looks
          # more reasonable than having DataTable of 1-2 rows.
          post_process { |h|
            h['weather2'] = h['weather'].last if h['weather'] && h['weather'].count > 1
          }
          post_process('weather', &:first)

          post_process('dt', &Time.method(:at))
          post_process('dt_txt') { nil } # TODO: we need cleaner way to say "remove this"
          post_process('sys.sunrise', &Time.method(:at))
          post_process('sys.sunset', &Time.method(:at))

          post_process('main.temp', &Reality::Measure['°C'].method(:units))
          post_process('main.temp_min', &Reality::Measure['°C'].method(:units))
          post_process('main.temp_max', &Reality::Measure['°C'].method(:units))
          post_process('main.humidity', &Reality::Measure['%'].method(:units))
          post_process('main.pressure', &Reality::Measure['hPa'].method(:units))

          # https://github.com/zverok/geo_coord promo here!
          post_process { |e|
            e['coord'] = Geo::Coord.new(e['coord.lat'], e['coord.lon']) if e['coord.lat'] && e['coord.lon']
          }
          post_process('coord.lat') { nil }
          post_process('coord.lon') { nil }

          # See http://openweathermap.org/weather-conditions#How-to-get-icon-URL
          post_process('weather.icon') { |i| "http://openweathermap.org/img/w/#{i}.png" }
        end

        # For endpoints returning weather in one place
        instance_eval(&WEATHER_POST_PROCESSOR)

        # For endpoints returning list of weathers (forecast or several
        # cities).
        post_process_items('list', &WEATHER_POST_PROCESSOR)
      end
    end
  end
end
