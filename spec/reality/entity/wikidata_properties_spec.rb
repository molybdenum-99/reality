module Reality
  describe Entity::WikidataProperties do
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
    subject(:hash){Entity::Wikidata.parse(wikidata)}

    it{should be_kind_of(Hash)}

    its(:keys){should contain_exactly(:continent, :area, :neighbours)}

    it 'should be parsed' do
      continent = hash[:continent]
      expect(continent).to be_an Entity
      expect(continent.name).to eq 'South America'

      expect(hash[:area]).to eq Measure.new(43_417_000, 'km²')

      neigh = hash[:neighbours]
      expect(neigh).to be_an Array
      expect(neigh.count).to eq 2
      expect(neigh.map(&:name)).to eq ['Bolivia', 'Brazil']
    end

    describe :coerce_value do
      def coerce(what, type, **opts)
        Entity::Wikidata.send(:coerce_value, what, type, **opts) # bye-bye incapsulation! :)
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
      end
    end
  end
  
  #describe Entity, 'properties from wikidata' do
    #let(:wikipage){double}
    #let(:wikidata){
      #Wikidata::Entity.new(
        #'dummy1' => [Wikidata::Link.new('Q18', 'South America')],
        #'dummy2' => [43_417_000],
        #'dummy3' => [Wikidata::Link.new('Q750', 'Bolivia'), Wikidata::Link.new('Q155', 'Brazil')]
      #)
    #}
    #let(:entity){Entity.new('Paris', wikipage: wikipage, wikidata: wikidata)}

    #before do
      #Entity::Wikidata.properties{
        #property :continent, 'dummy1', :entity
        #property :area, 'dummy2', :measure, unit: 'km²'
        #property :neighbours, 'dummy3', [:entity]
      #}
    #end

    #it 'parses all known properties into :values' do
    #end

    #it 'allows access to properties through methods' do
    #end
  #end
end
