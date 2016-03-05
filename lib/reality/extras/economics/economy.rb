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

        def inspect
          "#<%s (%s)>" % ['Economics::Economy', @country.name]
        end

        private

        #IMF Cross Country Macroeconomic Statistics
        #https://www.quandl.com/data/ODA/documentation/overview
        def indicators_info
          @indicators_info ||= YAML.load_file('lib/reality/extras/economics/indicators.yml')
        end
      end
    end
  end
end
