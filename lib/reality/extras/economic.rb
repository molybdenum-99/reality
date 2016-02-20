require 'quandl'
Quandl::ApiConfig.api_key = QUANDL_KEY
Quandl::ApiConfig.api_version = '2015-04-09'

module Reality
  module Extras
    class Economic
      class Indicator
        attr_reader :name, :code

        def initialize(name, code, country_code)
          @name = name
          @code = code
          @country_code = country_code
          @no_data = false
        end

        def current
          return dataset if @no_data
          history.last.value
        end

        def history
          return dataset if @no_data
          dataset.data.values.select{|v| v['date'] <= Date.today}.sort_by{|d| d['date']}
        end

        def prediction
          return dataset if @no_data
          dataset.data.values.select{|v| v['date'] > Date.today}.sort_by{|d| d['date']}
        end

        def dataset
          @dataset ||= fetch
        end

        def inspect
          "#<%s (%s)>" % ['Economic::Indicator', name]
        end

        private

        def fetch
          Quandl::Dataset.get("ODA/#{@country_code}_#{@code}")
        rescue Quandl::NotFoundError
          @no_data = true
          'no data'
        end
      end

      def initialize(country_code)
        @country_code = country_code
      end

      def indicators
        @indicators ||= indicators_codes.map do |desc, code|
          Indicator.new(desc, code, @country_code)
        end
      end

      private

      def indicators_codes
        {
          "Country GDP based on PPP Valuation, USD Billions" => "PPPGDP",
          "Current Account Balance, % of GDP" => "BCA_NGDPD",
          "Current Account Balance, USD Billions" => "BCA",
          "Employment, Millions" => "LE",
          "Exports of Goods and services, % change" => "TX_RPCH",
          "Exports of Goods, % change" => "TXG_RPCH",
          "GDP Corresponding to Fiscal Year, Current Prices, LCU Billions" => "NGDP_FY",
          "GDP Deflator" => "NGDP_D",
          "GDP at Constant Prices, % change" => "NGDP_RPCH",
          "GDP at Constant Prices, LCU Billions" => "NGDP_R",
          "GDP at Current Prices, LCU Billions" => "NGDP",
          "GDP at Current Prices, USD Billions" => "NGDPD",
          "GDP per Capita at Constant Prices, LCU" => "NGDPRPC",
          "GDP per Capita at Current Prices, LCU" => "NGDPPC",
          "GDP per Capita at Current Prices, USD" => "NGDPDPC",
          "General Government Gross Debt, % of GDP" => "GGXWDG_NGDP",
          "General Government Gross Debt, USD Billions" => "GGXWDG",
          "General Government Net Debt, % of GDP" => "GGXWDN_NGDP",
          "General Government Net Debt, USD Billions" => "GGXWDN",
          "General Government Net Lending/Borrowing, % of GDP" => "GGXCNL_NGDP",
          "General Government Net Lending/Borrowing, USD Billions" => "GGXCNL",
          "General Government Primary Net Lending/Borrowing, % of GDP Billions" => "GGXONLB_NGDP",
          "General Government Primary Net Lending/Borrowing, USD Billions" => "GGXONLB",
          "General Government Revenue, % of GDP" => "GGR_NGDP",
          "General Government Revenue, USD Billions" => "GGR",
          "General Government Structural Balance, % of GDP" => "GGSB_NPGDP",
          "General Government Structural Balance, USD Billions" => "GGSB",
          "General Government Total Expenditure, % of GDP" => "GGX_NGDP",
          "General Government Total Expenditure, USD Billions" => "GGX",
          "Gross National Savings, % of GDP" => "NGSD_NGDP",
          "Implied PPP Conversion Rate, LCU per USD" => "PPPEX",
          "Imports of Goods and services, % change" => "TM_RPCH",
          "Imports of Goods, % change" => "TMG_RPCH",
          "Inflation % change, Average Consumer Prices" => "PCPIPCH",
          "Inflation % change, End of Period Consumer Prices" => "PCPIEPCH",
          "Inflation Index, Average Consumer Prices" => "PCPI",
          "Inflation Index, End of Period Consumer Prices" => "PCPIE",
          "Output Gap, % of potential GDP" => "NGAP_NPGDP",
          "Per Capita GDP based on PPP Valuation, USD" => "PPPPC",
          "Population, Millions" => "LP",
          "Share of World GDP based on PPP, %" => "PPPSH",
          "Total Investment, % of GDP" => "NID_NGDP",
          "Unemployment Rate, % of Total Labor Force" => "LUR"
        }
      end
    end
  end
end
