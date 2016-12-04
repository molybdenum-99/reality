require 'reality/observation'

module Reality
  describe Observation do
    subject(:observation) {
      described_class.new(timestamp: Date.new(2016, 5, 1), value: 30, source: :wikidata)
    }

    its(:timestamp) { is_expected.to eq Date.new(2016, 5, 1) }
    its(:value) { is_expected.to eq 30 }
    its(:source) { is_expected.to eq :wikidata }

    describe '#==' do
      it { is_expected.to eq described_class.new(timestamp: Date.new(2016, 5, 1), value: 30, source: :wikidata) }
      it { is_expected.not_to eq described_class.new(timestamp: Date.new(2016, 5, 2), value: 30, source: :wikidata) }
      it { is_expected.not_to eq described_class.new(timestamp: Date.new(2016, 5, 1), value: 31, source: :wikidata) }
      it { is_expected.not_to eq described_class.new(timestamp: Date.new(2016, 5, 1), value: 30, source: :wikipedia) }
    end

    describe '#inspect' do
      its(:inspect) { is_expected.to eq '#<Reality::Observation 2016-05-01 - 30 (wikidata)>' }

      context 'without source' do
        subject(:observation) {
          described_class.new(timestamp: Date.new(2016, 5, 1), value: 30)
        }

        its(:inspect) { is_expected.to eq '#<Reality::Observation 2016-05-01 - 30>' }
      end
    end
  end
end
