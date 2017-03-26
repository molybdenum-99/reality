module Reality
  describe Observation do
    describe '#initialize' do
      subject { described_class.new(:name, 'Vasya') }
      its(:name) { is_expected.to eq :name }
      its(:value) { is_expected.to eq 'Vasya' }
    end

    describe '#inspect' do
      subject { described_class.new(:name, 'Vasya') }
      its(:inspect) { is_expected.to eq '#<Reality::Observation name=Vasya>' }
    end

    context 'with time' do
      subject { described_class.new(:name, 'Vasya', time: Time.parse('2017-03-26 12:30')) }

      its(:name) { is_expected.to eq :name }
      its(:value) { is_expected.to eq 'Vasya' }
      its(:time) { is_expected.to eq Time.parse('2017-03-26 12:30') }
      it { is_expected.to be_timed }
      its(:inspect) { is_expected.to eq '#<Reality::Observation name=Vasya (2017-03-26 at 12:30:00)>' }
    end
  end
end
