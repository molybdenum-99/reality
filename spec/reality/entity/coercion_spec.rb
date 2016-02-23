module Reality
  describe Entity::Coercion do
    def coerce(what, type, **opts)
      Entity::Coercion.coerce(what, type, **opts)
    end

    let(:neighbours){
      {'Q750' => 'Bolivia', 'Q155' => 'Brazil',
        'Q298' => 'Chile', 'Q733' => 'Paraguay',
        'Q77' => 'Uruguay'}
    }
    
    it 'coerces to entity' do
      continent = coerce([Wikidata::Link.new('Q18', 'South America')], :entity)
      expect(continent).to be_an Entity
      expect(continent.name).to eq 'South America'

      link = Infoboxer::Tree::Wikilink.new('Paris', Infoboxer::Tree::Text.new('capital of France'))
      continent = coerce([link], :entity)
      expect(continent).to be_an Entity
      expect(continent.name).to eq 'Paris'
    end

    it 'coerces to measure' do
      expect(
        coerce([43_417_000], :measure, unit: 'person')
      ).to eq Measure.new(43_417_000, 'person')

      expect(
        coerce('2,780,400', :measure, unit: 'km²')
      ).to eq Measure.new(2_780_400, 'km²')
    end

    it 'coerces to string' do

      expect(coerce(['ARG'], :string)).to eq 'ARG'
      expect(
        coerce([Wikidata::Link.new('Q38300', '.ar')], :string)
      ).to eq '.ar'
    end

    it 'coerces to utc offset' do
      expect(
        coerce([Wikidata::Link.new('Q651', 'UTC−03:00')], :utc_offset)
      ).to eq -3
    end

    it 'coerces to geo coords' do
      expect(
        coerce([Geo::Coord.new(49, 32)], :coord)
      ).to eq Geo::Coord.new(49, 32)

      expect(
        coerce(['49 32'], :coord)
      ).to be_nil
    end

    it 'coerces to datime' do
      t = DateTime.now
      expect(
        coerce([t], :datetime)
      ).to eq t

      expect(
        coerce(['2010-01-20'], :datetime)
      ).to be_nil
    end

    it 'coerces arrays' do
      arr = neighbours.map{|i, l| Wikidata::Link.new(i, l)}

      neigh = coerce(arr, [:entity])
      expect(neigh.count).to eq neighbours.count
      expect(neigh).to all be_an Entity
      expect(neigh.map(&:name)).to contain_exactly *neighbours.values
    end

    it 'supporst custom parsers' do

      parser = ->(var){
        Util::Parse.scaled_number(var.text.strip.sub(/^((Int|US)?\$|USD)/, ''))
      }
      expect(
        coerce(double(text: '$964.279 billion'), :measure, unit: '$', parse: parser)
      ).to eq Measure.new(964_279_000_000, '$')
    end
  end
end
