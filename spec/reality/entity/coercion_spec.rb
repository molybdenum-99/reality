module Reality
  describe Entity::Coercion do
      def coerce(what, type, **opts)
        Entity::Coercion.coerce(what, type, **opts)
      end
      
      it 'works!' do
        continent = coerce([Wikidata::Link.new('Q18', 'South America')], :entity)
        expect(continent).to be_an Entity
        expect(continent.name).to eq 'South America'

        expect(
          coerce([43_417_000], :measure, unit: 'person')
        ).to eq Measure.new(43_417_000, 'person')

        expect(coerce(['ARG'], :string)).to eq 'ARG'
        expect(
          coerce([Wikidata::Link.new('Q38300', '.ar')], :string)
        ).to eq '.ar'

        expect(
          coerce([Wikidata::Link.new('Q651', 'UTC−03:00')], :utc_offset)
        ).to eq -3

        expect(
          coerce([Geo::Coord.new(49, 32)], :coord)
        ).to eq Geo::Coord.new(49, 32)

        expect(
          coerce(['49 32'], :coord)
        ).to be_nil

        # TODO: arrays, custom parsers
      end
  end
end
