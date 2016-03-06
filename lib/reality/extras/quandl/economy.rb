module Reality
  module Extras
    module Quandl
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
          "#<Reality::Quandl::Economy (%s)>" % [@country.name]
        end

        private

        def indicators_info
          @indicators_info ||= YAML.load_file('lib/reality/extras/quandl/indicators.yml')
        end
      end
    end
  end
end
