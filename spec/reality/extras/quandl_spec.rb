module Reality
  module Extras::Quandl
    describe Economy do
      let(:country) { double(iso3_code: 'UKR', name: 'United Ruby') }

      subject(:economy) { described_class.new(country) }

      # Now those are somehow fail on Travis (not using VCR cassettes?..), so...
      xdescribe '#inflation', :vcr do
        subject { economy.inflation }

        it{should == Reality::Measure(49.979, '%')}
      end

      xdescribe '#unemployment', :vcr do
        subject { economy.unemployment }

        it{should == Reality::Measure(11.467, '%')}
      end

      describe '#gdp', :vcr do
        subject { economy.gdp }

        it{should == Reality::Measure(90_000_000_000, '$')}
      end
    end
  end
end
