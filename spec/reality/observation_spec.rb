require 'reality/observation'

module Reality
  describe Observation do
    subject(:observation) {
      described_class.new(Date.new(2016, 5, 1), 30, source: :wikidata)
    }

    its(:timestamp) { is_expected.to eq Date.new(2016, 5, 1) }
    its(:value) { is_expected.to eq 30 }
    its(:source) { is_expected.to eq :wikidata }

    describe '#==' do
      context 'with other observation' do
        it { is_expected.to eq described_class.new(Date.new(2016, 5, 1), 30, source: :wikidata) }
        it { is_expected.not_to eq described_class.new(Date.new(2016, 5, 2), 30, source: :wikidata) }
        it { is_expected.not_to eq described_class.new(Date.new(2016, 5, 1), 31, source: :wikidata) }
        it { is_expected.not_to eq described_class.new(Date.new(2016, 5, 1), 30, source: :wikipedia) }
      end

      context 'with value' do
        it { is_expected.to eq 30 }
        it { is_expected.not_to eq 31 }
      end
    end

    describe '#inspect' do
      its(:inspect) { is_expected.to eq '#<Reality::Observation 2016-05-01 - 30 (wikidata)>' }

      context 'without source' do
        subject(:observation) {
          described_class.new(Date.new(2016, 5, 1), 30)
        }

        its(:inspect) { is_expected.to eq '#<Reality::Observation 2016-05-01 - 30>' }
      end
    end

    describe '#to_s' do
      its(:to_s) { is_expected.to eq '30' }
    end

    describe 'coercion' do
      context 'unary method' do
        subject { -observation }

        it { is_expected.to eq described_class.new(Date.new(2016, 5, 1), -30, source: :wikidata) }
      end

      context 'method with plain values' do
        subject { observation / operand }

        let(:operand) { 2 }

        it { is_expected.to eq described_class.new(Date.new(2016, 5, 1), 15, source: :wikidata) }
      end

      context 'method with other obs' do
        subject { observation / operand }

        context 'with same timestamp' do
          let(:operand) { described_class.new(Date.new(2016, 5, 1), 2, source: :wikidata) }

          it { is_expected.to eq described_class.new(Date.new(2016, 5, 1), 15, source: :wikidata) }
        end

        context 'with different timestamps' do
          let(:operand) { described_class.new(Date.new(2016, 4, 1), 2, source: :wikidata) }

          it { is_expected.to eq described_class.new(Date.new(2016, 4, 1), 15, source: :wikidata) }
        end

        context 'with same source' do
          let(:operand) { described_class.new(Date.new(2016, 5, 1), 2, source: :wikidata) }

          it { is_expected.to eq described_class.new(Date.new(2016, 5, 1), 15, source: :wikidata) }
        end

        context 'with different sources' do
          let(:operand) { described_class.new(Date.new(2016, 5, 1), 2, source: :wikipedia) }

          it { is_expected.to eq described_class.new(Date.new(2016, 5, 1), 15, source: nil) }
        end
      end

    end
  end
end
