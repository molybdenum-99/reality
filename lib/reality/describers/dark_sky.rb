require 'tlaw'

module Reality
  module Describers
    class DarkSky < Abstract::Base
      def initialize(key)
        @api = API.new(api_key: key)
      end

      def find(lat_lng, at: nil)
        at ? forecast(*lat_lng, at) : current(*lat_lng)
      end

      def perform_query(params)
        lat, lng = case params
          when Array
            params
          when Geo::Coord
            params.latlng
          when Entity
            (params['coordinates'] || params['coordinate location'])&.latlng
          when /^\d+(?:\.\d+)?[,\| ;]\d+(?:\.\d+)?$/
            params.split(/[,\| ;]/).map(&:to_f)
          end

        @api.current(lat, lng).yield_self { |response|
          eid = response['currently.time'] # TODO: Find what to use as ID.
          response.map { |key, value|
            obs(eid, key, value)
          }
        }.yield_self(&method(:make_entities))
      end

      private

      def prefix
        'darksky'
      end

      class API < TLAW::API
        define do
          base 'https://api.darksky.net/forecast/{api_key}'

          param :api_key, required: true

          endpoint :current, '/{lat},{lng}?exclude=hourly,flags,daily,minutely' do
            param :lat, :to_f, required: true, desc: 'Latitude'
            param :lng, :to_f, required: true, desc: 'Longitude'
          end

          endpoint :forecast, '/{lat},{lng},{timestamp}?exclude=hourly,flags,daily,minutely' do
            param :lat, :to_f, required: true, desc: 'Latitude'
            param :lng, :to_f, required: true, desc: 'Longitude'
            param :timestamp, :to_i, required: true, desc: 'Timestamp'
          end
        end
      end
    
    end
  end
end

# TODO: Create ENV['DARK_SKY_APPID']
# Reality.describers['darksky'] = Reality.describers['dark_sky'] = Reality::Describers::DarkSky.new(ENV['DARK_SKY_APPID'])
