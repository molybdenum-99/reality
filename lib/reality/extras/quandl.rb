require 'quandl'

module Reality
  module Extras
    module Quandl
      class Economy
        def initialize(country)
          @country = country
        end

        def gdp
          gdp = fetch("ODA/#{@country.iso3_code}_NGDPD")
          gdp = gdp.to_i * 1_000_000_000
          Reality::Measure(gdp, '$')
        end

        def inflation
          inflation = fetch("ODA/#{@country.iso3_code}_PCPIPCH")
          Reality::Measure(inflation, '%')
        end

        def unemployment
          unemployment = fetch("ODA/#{@country.iso3_code}_LUR")
          Reality::Measure(unemployment, '%')
        end

        def inspect
          "#<Reality::Quandl::Economy (%s)>" % [@country.name]
        end

        private

        def fetch(code)
          ::Quandl::ApiConfig.api_key ||= Reality.config.fetch('keys', 'quandl')
          database, dataset = code.split('/')
          data = ::Quandl::Data.all({ params: { database_code: database, dataset_code: dataset }})
          data.values.select { |v| v['date'] <= Date.today }.sort_by { |d| d['date'] }.last.value
        rescue ::Quandl::NotFoundError
          nil
        end
      end

      module CountryEconomics
        def economy
          @economy ||= Extras::Quandl::Economy.new(self)
        end
      end

      def self.included(reality)
        reality.config.register('keys', 'quandl',
                                desc: 'Quandl API key. Can be obtained here: http://quandl.com')

        reality::Country.include CountryEconomics
      end
    end
  end
end
