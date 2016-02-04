module Reality
  describe Entity, :vcr do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox country'))}
    let(:wikidata){double}

    describe :wikipage do
      let(:wikipedia){double}
      before{
        allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
      }

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

    describe 'property definition' do
      let(:klass){
        Class.new(Entity) do
          property :continent,
            type: :entity,
            wikidata: 'P30'

          property :population,
            type: :measure,
            unit: 'person',
            wikidata: 'P1082'

          property :iso3_code, wikidata: 'P298'
          property :tld, wikidata: 'P78'

          property :neighbours,
            type: [:entity],
            wikidata: 'P47'

          property :utc_offset,
            type: :utc_offset,
            wikidata: 'P421'
        end
      }
      let(:country){klass.new('Argentina', wikidata: wikidata)}

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

        let(:neighbours){
          {'Q750' => 'Bolivia', 'Q155' => 'Brazil',
            'Q298' => 'Chile', 'Q733' => 'Paraguay',
            'Q77' => 'Uruguay'}
        }

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
    end

    describe 'type check' do
    end
  end
end
