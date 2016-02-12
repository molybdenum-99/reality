module Reality
  describe EntityProperties do
    let(:infobox){double}
    let(:wikipage){double(title: 'Paris, France', infobox: infobox)}
    let(:wikidata){double}
    let(:country){Entity.new('Argentina', wikidata: wikidata, wikipage: wikipage)}
    let(:neighbours){
      {'Q750' => 'Bolivia', 'Q155' => 'Brazil',
        'Q298' => 'Chile', 'Q733' => 'Paraguay',
        'Q77' => 'Uruguay'}
    }
    context 'Wikidata' do
      
      it 'loads entities' do
        expect(wikidata).to receive(:[]).with('P30').
          and_return([Wikidata::Link.new('Q18', 'South America')])

        continent = country.fetch(type: :entity, wikidata: 'P30')
        expect(continent).to be_an Entity
        expect(continent.name).to eq 'South America'
      end

      it 'loads measures' do
        expect(wikidata).to receive(:[]).with('P1082').
          and_return([43_417_000])

        expect(country.fetch(type: :measure, unit: 'person',
            wikidata: 'P1082')).to eq Measure.new(43_417_000, 'person')
      end

      it 'loads strings' do
        expect(wikidata).to receive(:[]).with('P298').
          and_return(['ARG'])

        expect(country.fetch(wikidata: 'P298')).to eq 'ARG'

        expect(wikidata).to receive(:[]).with('P78').
          and_return([Wikidata::Link.new('Q38300', '.ar')])

        expect(country.fetch(wikidata: 'P78')).to eq '.ar'
      end

      it 'loads arrays of entities' do
        expect(wikidata).to receive(:[]).with('P47').
          and_return(neighbours.map{|i, l| Wikidata::Link.new(i, l)})

        neigh = country.fetch(type: [:entity], wikidata: 'P47')
        expect(neigh.count).to eq neighbours.count
        expect(neigh).to all be_an Entity
        expect(neigh.map(&:name)).to contain_exactly *neighbours.values
      end

      it 'loads timezone' do
        expect(wikidata).to receive(:[]).with('P421').
          and_return([Wikidata::Link.new('Q651', 'UTC−03:00')])

        expect(country.fetch(type: :utc_offset, wikidata: 'P421')).to eq -3
      end

      it 'loads coordinates' do
        expect(wikidata).to receive(:[]).with('P625').
          and_return([Geo::Coord.new(49, 32)])

        expect(country.fetch(type: :coord, wikidata: 'P625')).to eq Geo::Coord.new(49, 32)

        expect(wikidata).to receive(:[]).with('P626').
          and_return(['49 32'])

        expect(country.fetch(type: :coord, wikidata: 'P626')).to be nil
      end
    end

    context 'Wikipedia' do
      it 'loads measures' do
        expect(infobox).to receive(:fetch).with('area_km2').
          and_return([double(to_s: '2,780,400')])

        expect(country.fetch(type: :measure, unit: 'km²',
            wikipedia: 'area_km2')).to eq Measure.new(2_780_400, 'km²')
      end

      it 'allows to use custom parser' do
        expect(infobox).to receive(:fetch).with('GDP_PPP').
          and_return([double(text: '$964.279 billion')])

        expect(country.fetch(type: :measure, unit: '$',
            wikipedia: 'GDP_PPP',
            parse: ->(var){
              Util::Parse.scaled_number(var.text.strip.sub(/^((Int|US)?\$|USD)/, ''))
            })).to eq Measure.new(964_279_000_000, '$')
      end
    end
  end
end
