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
  end
end
