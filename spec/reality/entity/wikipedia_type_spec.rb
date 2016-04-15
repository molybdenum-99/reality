module Reality
  describe Entity::WikipediaType do
    subject(:type){
      Module.new{
        extend Entity::WikipediaType
      }
    }
    let(:object){double}

    describe 'property definition' do
    end

    describe 'guessing by infobox' do
      subject(:type2){
        Module.new{
          extend Entity::WikipediaType
        }
      }
      before{
        # XX for not mangle our real existing definitions
        type.infobox_name 'Infobox settlementXX', 'Infobox cityXX'
        type2.infobox_name 'Infobox countryXX'
      }
      let(:obj1){
        double(wikipage: double(infobox: double(name: 'Infobox settlementXX')))
      }
      let(:obj2){
        double(wikipage: double(infobox: double(name: 'Infobox countryXX')))
      }
      it 'should guess correctly' do
        expect(Entity::WikipediaType.for(obj1)).to eq type
        expect(Entity::WikipediaType.for(obj2)).to eq type2
      end
    end

    describe 'symbol' do
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

      its(:symbol){should == :country_x}
    end

    describe 'inclusion' do
      let(:infobox){double(name: '')}
      let(:wikipage){double(title: 'Paris, France', infobox: infobox)}
      let(:wikidata){double(predicates: {})}
      let(:entity){Entity.new('Argentina').setup!(wikidata: wikidata, wikipage: wikipage)}

      subject(:type){
        Module.new{
          extend Entity::WikipediaType

          infobox 'area_km2', :area, :measure, unit: 'km²'

          infobox 'GDP_PPP', :gdp_ppp, :measure, unit: '$',
                    parse: ->(var){
                      str = var.text.strip.sub(/^((Int|US)?\$|USD)/, '')
                      Util::Parse.scaled_number(str)
                    }

          parse :regions, [:entity] do |page|
            [Infoboxer::Tree::Wikilink.new('Cuyo'), Infoboxer::Tree::Wikilink.new('Pampas')]
          end
        }
      }
      before{
        entity.values[:area] = Measure.new(43_417_000, 'km²')
        
        expect(infobox).to receive(:fetch).with('area_km2').
          and_return([double(to_s: '2,780,400')]).ordered
        expect(infobox).to receive(:fetch).with('GDP_PPP').
          and_return([double(text: '$964.279 billion')]).ordered
          
        entity.extend(type)
      }
      it 'parses properties' do
        expect(entity.gdp_ppp).to eq Measure.new(964_279_000_000, '$')
      end

      it 'does not rewrite existing properties' do
        expect(entity.area).to eq Measure.new(43_417_000, 'km²')
      end

      it 'parsers free parsers' do
        expect(entity.regions.count).to eq 2
        expect(entity.regions).to all be_an Entity
        expect(entity.regions.map(&:name)).to eq ['Cuyo', 'Pampas']
      end
    end
  end
end
