module Reality
  module Extras::Quandl
    describe Economy do
      let(:country) { double(iso3_code: 'UKR', name: 'United Ruby') }

      describe '#indicators' do
        subject { described_class.new(country) }

        it 'returns list of indicators' do
          expect(subject.indicators.first).to be_a(Indicator)
        end
      end
    end

    describe Indicator do
      let(:country) { double(iso3_code: 'UKR', name: 'United Ruby') }

      subject(:indicator) { described_class.new(country, 'PPPGDP', {name: 'PPPGDP'}) }

      before do
        VCR.use_cassette('QUANDL-IMF') { indicator.data }
      end

      describe '#current' do
        it 'returns value' do
          expect(indicator.current).to be_a(Float)
        end
      end

      describe '#history' do
        subject { indicator.history }

        it 'returns hash with dates and values' do
          expect(subject[0]['date']).to be_a(Date)
          expect(subject[0]['value']).to be_a(Float)
        end
      end

      describe '#prediction' do
        subject { indicator.prediction }

        it 'returns hash with dates and values' do
          expect(subject[0]['date']).to be_a(Date)
          expect(subject[0]['value']).to be_a(Float)
        end
      end
    end
  end
end
