require 'reality/variable'
require 'reality/observation'

module Reality
  describe Variable do
    before { Timecop.freeze('2016-05-01') }
    after { Timecop.return }

    let(:observations) {
      [
        Observation.new(Date.parse('2016-04-01'), 10, source: :wikipedia),
        Observation.new(Date.parse('2016-04-01'), 11, source: :wikidata),
        Observation.new(Date.parse('2016-04-15'), 12, source: :wikipedia),
        Observation.new(Date.parse('2016-05-06'), 14, source: :wikipedia),
      ]
    }

    subject(:variable) { described_class.new(:temperature, observations) }

    describe '#observations' do
      its(:observations) { is_expected.to eq observations }
    end

    describe '#before' do
      subject { variable.before(Date.parse('2016-04-14')) }

      its(:observations) { are_expected.to eq [
        Observation.new(Date.parse('2016-04-01'), 10, source: :wikipedia),
        Observation.new(Date.parse('2016-04-01'), 11, source: :wikidata)
      ]}
    end

    describe '#after' do
      subject { variable.after(Date.parse('2016-04-14')) }

      its(:observations) { are_expected.to eq [
        Observation.new(Date.parse('2016-04-15'), 12, source: :wikipedia),
        Observation.new(Date.parse('2016-05-06'), 14, source: :wikipedia)
      ]}
    end

    describe '#at' do
      subject { variable.at(Date.parse('2016-04-01')) }

      it { is_expected.to eq Observation.new(Date.parse('2016-04-01'), 11, source: :wikidata) }

      context 'before observation start' do
        subject { variable.at(Date.parse('2015-04-01')) }

        it { is_expected.to be_nil }
      end
    end

    describe '#historical'
    describe '#predicted'
    describe '#current' do
      subject { variable.current }

      it { is_expected.to eq Observation.new(Date.parse('2016-04-15'), 12, source: :wikipedia) }
    end

    describe '#uniq' do
      context 'when preferred source order not set' do
      end

      context 'when preferred source order is set' do
      end
    end

    describe '#from' do
      subject { variable.from(:wikipedia) }

      its(:observations) { are_expected.to eq [
        Observation.new(Date.parse('2016-04-01'), 10, source: :wikipedia),
        Observation.new(Date.parse('2016-04-15'), 12, source: :wikipedia),
        Observation.new(Date.parse('2016-05-06'), 14, source: :wikipedia),
      ]}
    end

    describe '#inspect' do
      its(:inspect) { is_expected.to eq '#<Reality::Variable temperature (2016-04-01 - 2016-05-06): 12>' }
    end

    describe '#to_s' do
      its(:to_s) { is_expected.to eq '12' }
    end
  end
end
