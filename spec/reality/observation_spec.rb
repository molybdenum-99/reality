require 'reality/observation'

module Reality
  describe Observation do
    subject(:observation) {
      described_class.new(_index: Date.new(2016, 5, 1), _type: 'Weather', temp: 30, humidity: 50, sky: 'clear')
    }

    its(:variables) { is_expected.to eq %i[temp humidity sky] }

    context 'behaving like const struct' do
      its(:temp) { is_expected.to eq 30 }
      it { expect { observation.city }.to raise_error(NoMethodError) }
    end

    context 'behaving like const hash' do
      its([:temp]) { is_expected.to eq 30 }
      it { expect { observation[:temp] = 40 }.to raise_error(NoMethodError) }
      it { expect { observation[:city] }.to raise_error(KeyError) }
    end

    describe '#inspect' do
      its(:inspect) { is_expected.to eq('#<Reality::Observation(Weather): 2016-05-01 - temp: 30, humidity: 50, sky: "clear">') }
    end
  end
end
