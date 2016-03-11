module Reality
  describe Entity, 'wikipedia type and properties' do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox countryXX'))}
    let(:wikidata){double(predicates: {})}
    let(:wikipedia){double}
    before{
      allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
    }

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
