require_relative 'economics/indicator'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
Reality.configure(:demo)

module Reality
  module Extras
    module Economics
      class Economy
        def initialize(country)
          @country = country
        end

        def indicators
          @indicators ||= indicators_info.map do |code, info|
            Indicator.new(@country, code, info)
          end
        end

        private

        #IMF Cross Country Macroeconomic Statistics
        #https://www.quandl.com/data/ODA/documentation/overview
        def indicators_info
          @indicators_info ||= YAML.load_file('lib/reality/extras/economics/indicators.yml')
        end
      end

      module CountryEconomic
        def economy
          @economy ||= Extras::Economics::Economy.new(self)
        end
      end

      def self.included(reality)
        reality.config.register('keys', 'quandl',
                                desc: 'Quandl API key. Can be obtained here: http://quandl.com')

        reality::Country.include CountryEconomic
      end
    end
  end
end
