module Reality
  describe Entity, :vcr do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox country'))}
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

        expect(entity.wikipage).to eq wikipage
        expect(entity.instance_variable_get('@wikipage')).to eq wikipage
      end
    end

    describe :wikidata do
      it 'is not loaded by default' do
        expect(entity.instance_variable_get('@wikipage')).to be_nil
      end

      it 'is loaded as Wikidata::Entity on first call' do
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris').and_return([wikidata])

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
          with('Paris').and_return([wikidata])

        entity.load!

        expect(entity.instance_variable_get('@wikidata')).to eq wikidata
        expect(entity.instance_variable_get('@wikipage')).to eq wikipage
      end
      
      it 'force-loads on initialize' do
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris').and_return(wikipage)
        expect(Wikidata::Entity).to receive(:fetch).
          with('Paris').and_return([wikidata])

        entity = Entity.new('Paris', load: true)

        expect(entity.instance_variable_get('@wikidata')).to eq wikidata
        expect(entity.instance_variable_get('@wikipage')).to eq wikipage

      end
    end

    describe 'property definition' do
      let(:klass){
        Class.new(Entity) do
          # from Wikidata
          property :continent, type: :entity, wikidata: 'P30'

          property :population, type: :measure, unit: 'person',
            wikidata: 'P1082'

          property :iso3_code, wikidata: 'P298'
          property :tld, wikidata: 'P78'

          property :neighbours, type: [:entity], wikidata: 'P47'

          property :utc_offset, type: :utc_offset, wikidata: 'P421'

          # from Wikipedia
          property :area, type: :measure, unit: 'km²',
            wikipedia: 'area_km2'

          property :gdp_ppp, type: :measure, unit: '$',
            wikipedia: 'GDP_PPP',
            parse: ->(var){
              Util::Parse.scaled_number(var.text.strip.sub(/^((Int|US)?\$|USD)/, ''))
            }
        end
      }
      let(:country){klass.new('Argentina', wikidata: wikidata, wikipage: wikipage)}
      let(:neighbours){
        {'Q750' => 'Bolivia', 'Q155' => 'Brazil',
          'Q298' => 'Chile', 'Q733' => 'Paraguay',
          'Q77' => 'Uruguay'}
      }

      context 'Wikidata' do
        it 'loads entities' do
          expect(wikidata).to receive(:[]).with('P30').
            and_return([Wikidata::Link.new('Q18', 'South America')])

          continent = country.continent
          expect(continent).to be_an Entity
          expect(continent.name).to eq 'South America'
        end

        it 'loads measures' do
          expect(wikidata).to receive(:[]).with('P1082').
            and_return([43_417_000])

          expect(country.population).to eq Measure.new(43_417_000, 'person')
        end

        it 'loads strings' do
          expect(wikidata).to receive(:[]).with('P298').
            and_return(['ARG'])

          expect(country.iso3_code).to eq 'ARG'

          expect(wikidata).to receive(:[]).with('P78').
            and_return([Wikidata::Link.new('Q38300', '.ar')])

          expect(country.tld).to eq '.ar'
        end

        it 'loads arrays of entities' do
          expect(wikidata).to receive(:[]).with('P47').
            and_return(neighbours.map{|i, l| Wikidata::Link.new(i, l)})

          neigh = country.neighbours
          expect(neigh.count).to eq neighbours.count
          expect(neigh).to all be_an Entity
          expect(neigh.map(&:name)).to contain_exactly *neighbours.values
        end

        it 'loads timezone' do
          expect(wikidata).to receive(:[]).with('P421').
            and_return([Wikidata::Link.new('Q651', 'UTC−03:00')])

          expect(country.utc_offset).to eq -3
        end
      end

      context 'Wikipedia' do
        let(:infobox){double}
        let(:wikipage){double(title: 'Paris, France', infobox: infobox)}

        it 'loads measures' do
          expect(infobox).to receive(:fetch).with('area_km2').
            and_return([double(to_s: '2,780,400')])

          expect(country.area).to eq Measure.new(2_780_400, 'km²')
        end

        it 'allows to use custom parser' do
          expect(infobox).to receive(:fetch).with('GDP_PPP').
            and_return([double(text: '$964.279 billion')])

          expect(country.gdp_ppp).to eq Measure.new(964_279_000_000, '$')
        end
      end

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

    describe 'type check' do
    end
  end
end
