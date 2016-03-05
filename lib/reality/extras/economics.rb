require_relative 'economics/indicator'
require_relative 'economics/economy'

module Reality
  module Extras
    module Economics
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
