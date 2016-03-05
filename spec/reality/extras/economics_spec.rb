module Reality
  module Extras::Economics
    describe Indicator do
      let(:country) { double(iso3_code: 'UKR') }

      subject(:indicator) { described_class.new(country, 'PPPGDP', { name: 'PPPGDP' }) }

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
