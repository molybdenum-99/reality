module Reality
  describe Entity, 'wikidata properties' do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox countryXX'))}
    let(:wikidata){double(predicates: {})}
    let(:wikipedia){double}
    before{
      allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
    }

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
    subject(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}

    it 'parses all recognized properties on load' do
      expect(entity.values).to be_a Hash
      expect(entity.values).to include(:continent, :area, :neighbours)
    end

    it 'provides access through method_missing' do
      expect(entity.area).to eq Reality::Measure.new(43_417_000, 'km²')
    end

    it 'force-loads on method_missing' do
      expect(Infoboxer.wikipedia).to receive(:get).
        with('Paris').and_return(wikipage)
      expect(Wikidata::Entity).to receive(:one_by_wikititle).
        with('Paris, France').and_return(wikidata)

      entity = Entity.new('Paris')
      entity.area
      expect(entity).to be_loaded
    end
  end
end
