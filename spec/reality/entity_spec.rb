module Reality
  describe Entity, :vcr do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox countryXX'))}
    let(:wikidata){double}
    let(:wikipedia){double}
    before{
      allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
    }

    describe :wikipage do
      it 'is not loaded by default' do
        expect(entity.instance_variable_get('@wikipage')).to be_nil
      end

      it 'is loaded from infoboxer on first call' do
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris').and_return(wikipage)
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris, France').and_return([wikidata])

        expect(entity.wikipage).to eq wikipage
        expect(entity.instance_variable_get('@wikipage')).to eq wikipage
      end
    end

    describe :wikidata do
      it 'is not loaded by default' do
        expect(entity.instance_variable_get('@wikipage')).to be_nil
      end

      it 'is loaded as Wikidata::Entity on first call' do
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris').and_return(wikipage)
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris, France').and_return([wikidata])

        expect(entity.wikidata).to eq wikidata
        expect(entity.instance_variable_get('@wikidata')).to eq wikidata
      end
    end

    describe :inspect do
      its(:inspect){should == '#<Reality::Entity(Paris)>'}
    end

    describe :to_s do
      its(:to_s){should == 'Paris'}
    end

    describe 'preloading' do
      subject(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}

      it 'should consider data loaded' do
        expect(entity.wikipage).to eq wikipage
        expect(entity.wikidata).to eq wikidata
      end
    end

    describe 'forced loading' do
      it 'force-loads on demand' do
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris').and_return(wikipage)
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris, France').and_return([wikidata])

        entity.load!

        expect(entity.instance_variable_get('@wikidata')).to eq wikidata
        expect(entity.instance_variable_get('@wikipage')).to eq wikipage
      end
      
      it 'force-loads on initialize' do
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris').and_return(wikipage)
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris, France').and_return([wikidata])

        entity = Entity.new('Paris', load: true)

        expect(entity.instance_variable_get('@wikidata')).to eq wikidata
        expect(entity.instance_variable_get('@wikipage')).to eq wikipage

      end
    end

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
