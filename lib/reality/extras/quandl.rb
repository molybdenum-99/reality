require_relative 'quandl/indicator'
require_relative 'quandl/economy'

module Reality
  module Extras
    module Quandl
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
