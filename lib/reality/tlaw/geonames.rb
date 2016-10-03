require 'tlaw'

module Reality
  module TLAW
    class GeoNames < ::TLAW::API
      define do
        base 'http://api.geonames.org'

        param :username, required: true

        endpoint :timezone, '/timezoneJSON' do
          param :lat, :to_f, keyword: false, required: true
          param :lng, :to_f, keyword: false, required: true
        end
      end
    end
  end
end
