module Reality
  describe Entity::WikidataPredicates do
    before do
      Entity::WikidataPredicates.define{
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
    subject(:hash){Entity::WikidataPredicates.parse(wikidata)}

    it{should be_kind_of(Hash)}

    its(:keys){should contain_exactly(:continent, :area, :neighbours)}

    it 'should be parsed' do
      continent = hash[:continent]
      expect(continent).to be_an Entity
      expect(continent.name).to eq 'South America'

      expect(hash[:area]).to eq Measure.new(43_417_000, 'km²')

      neigh = hash[:neighbours]
      expect(neigh).to be_an Array
      expect(neigh.count).to eq 2
      expect(neigh.map(&:name)).to eq ['Bolivia', 'Brazil']
    end
  end
end
