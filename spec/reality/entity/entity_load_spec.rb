module Reality
  describe Entity, 'loading' do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox countryXX'))}
    let(:wikidata){double(predicates: {})}
    let(:wikipedia){double}
    before{
      allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
    }

    context 'when created' do
      it{should_not be_loaded}
      it 'has empty wikipage and data' do
        expect(entity.instance_variable_get('@wikipage')).to be_nil
        expect(entity.instance_variable_get('@wikidata')).to be_nil
      end

      its(:inspect){should == '#<Reality::Entity?(Paris)>'}
    end

    context 'when loaded' do
      before{
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris').and_return(wikipage)
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris, France').and_return([wikidata])

        entity.load!
      }
      it{should be_loaded}
      it 'has non-empty wikipage and data' do
        expect(entity.instance_variable_get('@wikipage')).to eq wikipage
        expect(entity.instance_variable_get('@wikidata')).to eq wikidata
      end
      its(:name){should == 'Paris, France'}
      its(:inspect){should == '#<Reality::Entity(Paris, France)>'}
    end

    context 'loading on wikidata id' do
      let(:wikidata){double(predicates: {},
        en_wikipage: 'Paris, France'
      )}
      subject(:entity){Entity.new('Paris', wikidata_id: 'Q111')}
      before{
        expect(Wikidata::Entity).to receive(:fetch_by_id).
          with('Q111').and_return(wikidata)
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris, France').and_return(wikipage)

        entity.load!
      }
      it{should be_loaded}
    end

    context 'fallback to wikidata label search' do
      let(:wikidata){double(predicates: {'P625' => Geo::Coord.new(41.918936, 12.501193)})}
      subject(:entity){Entity.new('Piper Club')}
      before{
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Piper Club').and_return(nil)
        expect(Wikidata::Entity).to receive(:fetch_by_label).
          with('Piper Club').and_return([wikidata])

        entity.load!
      }
      it{should be_loaded}
      its(:wikipage){should be_nil}
      its(:values){should_not be_empty}
    end

    context 'loading on initialize' do
      before{
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris').and_return(wikipage)
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris, France').and_return([wikidata])
      }

      subject(:entity){Entity.new('Paris', load: true)}
      it{should be_loaded}
    end

    context 'when prepopulated with data' do
      subject(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}

      it 'should consider data loaded' do
        expect(entity.wikipage).to eq wikipage
        expect(entity.wikidata).to eq wikidata
      end
      it{should be_loaded}
      its(:name){should == 'Paris, France'}
    end

    context 'when prepopulated with Wikipedia only' do
    end
  end
end
