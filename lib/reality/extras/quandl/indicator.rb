require 'quandl'
Quandl::ApiConfig.api_version = '2015-04-09'

module Reality
  module Extras
    module Quandl
      class Indicator
        attr_reader :name, :code, :unit, :scale, :country

        def initialize(country, code, info)
          ::Quandl::ApiConfig.api_key = Reality.config.fetch('keys', 'quandl')

          @name = info['name']
          @unit = info['unit']
          @scale = info['scale'] || 1
          @code = code
          @country = country
        end

        def current
          return 'no data' if data.nil?
          history.last.value
        end

        def history
          return 'no data' if data.nil?
          data.values.select { |v| v['date'] <= Date.today }.sort_by { |d| d['date'] }
        end

        def prediction
          return 'no data' if data.nil?
          data.values.select { |v| v['date'] > Date.today }.sort_by { |d| d['date'] }
        end

        def data
          @data ||= fetch
        end

        def inspect
          "#<Reality::Quandl::Indicator (%s)>" % [name]
        end

        private

        def fetch
          ::Quandl::Data.all({ params: { database_code: "ODA", dataset_code: "#{@country.iso3_code}_#{@code }" }})
        rescue ::Quandl::NotFoundError
          nil
        end
      end
    end
  end
end
