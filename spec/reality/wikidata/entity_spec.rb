require 'reality/wikidata'

module Reality
  describe Wikidata::Entity do
    describe '.from_sparql' do
      subject(:entity){
        Wikidata::Entity.from_sparql(source,
          subject: 'id',
          predicate: 'p', 
          object: 'o',
          object_label: 'oLabel').first
      }

      context('Ukraine'){
        let(:source){File.read('spec/fixtures/ukraine_sparql.json')}

        its(:id){should == 'Q212'}
        its(:label){should == 'Ukraine'}

        it 'parses literals' do
          expect(entity['P298'].first).to eq 'UKR'
          expect(entity['P1082'].first).to eq 42_800_501
        end

        it 'filters by language' do
          expect(entity['P1549']).to be_empty
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
      }
      context('JFK'){
        let(:source){File.read('spec/fixtures/JFK_murder_sparql.json')}
        it 'parses datetime' do
          expect(entity['P585'].first).to eq DateTime.parse("1963-11-22T00:00:00Z")
        end
      }
    end

    describe '.fetch' do
      context 'by [Wikipedia] title' do
        subject(:entity){
          VCR.use_cassette('Wikidata-Ukraine'){
            Wikidata::Entity.fetch('Ukraine').first
          }
        }

        its(:id){should == 'Q212'}

        it 'should have the properties' do
          expect(entity['P625'].first).to eq Reality::Geo::Coord.new(49.0, 32.0)
        end
      end
    end

    describe '.fetch_by_id' do
      subject(:entity){
        VCR.use_cassette('Wikidata-Q2599'){
          Wikidata::Entity.fetch_by_id('Q2599')
        }
      }

      its(:id){should == 'Q2599'}
      its(:en_wikipage){should == 'Paul McCartney'}
    end

    describe '.fetch_by_label' do
      subject(:entity){
        VCR.use_cassette('Wikidata-PiperClub'){
          Wikidata::Entity.fetch_by_label('Piper Club').first
        }
      }

      its(:id){should == 'Q3905504'}
      its(:label){should == 'Piper Club'}
    end

    describe '.fetch_list' do
      subject(:list){
        VCR.use_cassette('Wikidata-3-countries'){
          Wikidata::Entity.fetch_list('Argentina', 'Bolivia', 'Chile')
        }
      }
      its(:count){should == 3}
      it 'should be loaded correctly' do
        expect(list.keys).to contain_exactly('Argentina', 'Bolivia', 'Chile')
        expect(list.values.map(&:id)).to contain_exactly('Q414', 'Q750', 'Q298')
      end

      context 'when some entity can not be found' do
      end
    end

    describe '.fetch_list_by_id' do
      subject(:list){
        VCR.use_cassette('Wikidata-3-countries-by-id'){
          Wikidata::Entity.fetch_list_by_id('Q414', 'Q750', 'Q298')
        }
      }
      its(:count){should == 3}
      it 'should be loaded correctly' do
        expect(list.keys).to contain_exactly('Q414', 'Q750', 'Q298')
        expect(list.values.map(&:en_wikipage)).to contain_exactly('Argentina', 'Bolivia', 'Chile')
      end

      context 'when some entity can not be found' do
      end
    end
  end
end
