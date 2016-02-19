module Reality
  describe Entity, :vcr do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox countryXX'))}
    let(:wikidata){double}
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
        Entity::WikidataProperties.define{
          property 'dummy1', :continent, :entity
          property 'dummy2', :area, :measure, unit: 'km²'
          property 'dummy3', :neighbours, [:entity]
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
    end

    describe 'type and properites from Wikipedia' do
    end
  end
end

__END__
    xdescribe 'property definition' do
      # Not sure where it should go, really
      
      context :to_h do
        let(:infobox){double}
        let(:wikipage){double(infobox: infobox)}
        let(:wikidata){Wikidata::Entity.new(
          'Q414',
          'P30'   => [Wikidata::Link.new('Q18', 'South America')],
          'P1082' => [43_417_000],
          'P298'  => ['ARG'],
          'P47'   => neighbours.map{|i, l| Wikidata::Link.new(i, l)},
          'P421'  => [Wikidata::Link.new('Q651', 'UTC−03:00')]
        )}

        before{
          expect(infobox).to receive(:fetch).with('area_km2').
            and_return([double(to_s: '2,780,400')]).ordered
          expect(infobox).to receive(:fetch).with('GDP_PPP').
            and_return([double(text: '$964.279 billion')]).ordered  
        }
        subject{country.to_h}
        it{should be_a Hash}
        its(:keys){should include(:continent, :area, :utc_offset)}
        its([:continent]){should == 'South America'}
        its([:area]){should == 2_780_400}
        its([:neighbours]){should include('Bolivia', 'Chile')}
      end
    end

    describe 'entity class' do
      let!(:klass){
        Module.new{
          extend EntityClass
          by_infobox 'Infobox countryXX' # don't mangle real defs

          property :continent, type: :entity, wikidata: 'P30'
        }
      }
      context 'class selection on load' do
        before{
          expect(Infoboxer.wikipedia).to receive(:get).
            with('Paris').and_return(wikipage)
          expect(Wikidata::Entity).to receive(:fetch).
            with('Paris, France').and_return([wikidata])

          entity.load!
        }
        its(:entity_class){should == klass}
      end

      context 'class selection for preloaded' do
        subject(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}
        its(:entity_class){should == klass}
      end

      context 'class properties availability' do
        subject(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}
        it{should respond_to(:continent)}
        its(:properties){should include(:continent)}
      end

      context 'inspect' do
        before{
          if Reality.const_defined?(:CountryX) # to not mangle with our real Country
            Reality.send(:remove_const, :CountryX)
          end
          Reality.const_set(:CountryX, klass)
        }
        after{
          if Reality.const_defined?(:CountryX)
            Reality.send(:remove_const, :CountryX)
          end
        }
        subject(:entity){Entity.new('France', wikipage: wikipage, wikidata: wikidata)}
        its(:inspect){should == "#<Reality::CountryX(France)>"}
      end
    end
  end
end
