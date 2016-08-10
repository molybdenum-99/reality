module Reality
  describe Definitions::Wikidata do
    before do
      described_class.define{
        predicate 'dummy1', :continent, :entity
        predicate 'dummy2', :area, :measure, unit: 'km²'
        predicate 'dummy3', :neighbours, [:entity]
      }
    end

    let(:wikidata){
      Wikidata::Entity.new('DUMMY',
        'dummy1' => [Wikidata::Link.new('Q18', 'South America')],
        'dummy2' => [43_417_000],
        'dummy3' => [Wikidata::Link.new('Q750', 'Bolivia'), Wikidata::Link.new('Q155', 'Brazil')]
      )
    }
    subject(:hash){described_class.parse(wikidata)}

    it{should be_kind_of(Hash)}

    its(:keys){should contain_exactly(:continent, :area, :neighbours)}

    context ':continent' do
      subject { hash[:continent] }
      it { is_expected.to be_an Entity }
      its(:name) { is_expected.to eq 'South America' }
    end

    its([:area]) { is_expected.to eq Measure.new(43_417_000, 'km²') }

    context ':neighbours' do
      subject { hash[:neighbours] }

      it { is_expected.to be_an Array }
      its(:count) { is_expected.to eq 2 }
      specify { expect(subject.map(&:name)).to eq ['Bolivia', 'Brazil'] }
    end
  end
end
