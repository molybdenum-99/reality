require 'reality/wikidata'

module Reality
  describe Wikidata::Entity do
    describe '.fetch' do
      context 'by [Wikipedia] title' do
      end

      context 'by id' do
      end
    end

    #describe 'properties access' do
      #before{
        #stub_request(:get
      #}
      #it 'returns property by id' do
        #expect(subject['P30']).to # wikidata entity Q46, with name Europe
        #expect(subject['P47']).to # list of ...
        #P298 # str UKR
        #P402 # url to OSM
        #P625 # coord
        #P421 # valid in period?..
        #P1082 # population
      #end

      #context 'by name' do
      #end
    #end

    describe '.from_sparql' do
      let(:source){File.read('spec/fixtures/ukraine_sparql.json')}
      subject(:entity){
        Wikidata::Entity.from_sparql(source,
          subject: 'id',
          predicate: 'p', 
          object: 'o',
          object_label: 'oLabel').first
      }

      its(:id){should == 'Q212'}

      it 'parses literals' do
        expect(entity['P298'].first).to eq 'UKR'
        expect(entity['P1082'].first).to eq 42_800_501
      end

      it 'parses uris' do
        uri = entity['P30'].first
        expect(uri).to be_a(Wikidata::Link)
        expect(uri.id).to eq 'Q46'
        expect(uri.label).to eq 'Europe'
      end

      it 'parses GeoSPARQL' do
        expect(entity['P625'].first).to eq Reality::Geo::Coord.new(49.0, 32.0)
      end

      it 'parses multi-value properties' do
        neighbours = entity['P47']
        expect(neighbours.count).to eq 12
        expect(neighbours).to all be_a(Wikidata::Link)
        expect(neighbours.map(&:id)).to include 'Q28'
      end
    end
  end
end
