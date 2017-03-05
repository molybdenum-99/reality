module Reality
  describe Link do
    subject { described_class.new(:wikidata, 'Q414') }

    describe '#initialize' do
      its(:source) { is_expected.to eq :wikidata }
      its(:id) { is_expected.to eq 'Q414' }
    end

    describe '#inspect' do
      its(:inspect) { is_expected.to eq '#<Reality::Link wikidata:Q414>' }
    end

    describe '#==' do
      it { is_expected.to eq Reality::Link.new(:wikidata, 'Q414') }
      it { is_expected.to_not eq Reality::Link.new(:wikidata, 'Q413') }
      it { is_expected.to_not eq Reality::Link.new(:wikipedia, 'Q414') }
    end
  end
end
