module Reality
  describe Entity, :vcr do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox countryXX'))}
    let(:wikidata){double(predicates: {})}
    let(:wikipedia){double}
    before{
      allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
    }

    its(:to_s){should == 'Paris'}

    context 'loading' do
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

    describe 'properties from Wikidata' do
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
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris, France').and_return([wikidata])

        entity = Entity.new('Paris')
        entity.area
        expect(entity).to be_loaded
      end
    end

    describe 'type and properites from Wikipedia' do
      let!(:type){
        Module.new{
          extend Entity::WikipediaType
          infobox_name 'Infobox countryXX' # don't mangle real defs

          infobox 'area_km2', :area, :measure, unit: 'km²'
        }
      }
      before{
        allow(wikipage.infobox).to receive(:fetch).with('area_km2').
          and_return([double(to_s: '2,780,400')]).ordered
      }
      context 'type selection on load' do
        before{
          expect(Infoboxer.wikipedia).to receive(:get).
            with('Paris').and_return(wikipage)
          expect(Wikidata::Entity).to receive(:fetch).
            with('Paris, France').and_return([wikidata])


          entity.load!
        }
        it{should be_a type}
      end

      context 'type selection for preloaded' do
        subject(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}
        it{should be_a type}
      end

      context 'values parsed' do
        subject(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}
        its(:values){should include(area: Measure.new(2_780_400, 'km²'))}
      end

      context 'inspect' do
        before{
          if Reality.const_defined?(:CountryX) # to not mangle with our real Country
            Reality.send(:remove_const, :CountryX)
          end
          Reality.const_set(:CountryX, type)
        }
        after{
          if Reality.const_defined?(:CountryX)
            Reality.send(:remove_const, :CountryX)
          end
        }
        subject(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}
        its(:inspect){should == "#<Reality::Entity(Paris, France):country_x>"}
      end
    end
  end
end
