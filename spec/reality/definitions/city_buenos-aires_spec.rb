module Reality
  describe Entity, 'samples' do
    describe 'existing city' do
      before(:all){
        VCR.use_cassette('City-Buenos-Aires'){
          @city = Reality.Entity('Buenos Aires') # parsed only once - faster tests
        }
      }

      subject(:city){@city}

      its(:wikipedia_type){should == Reality::City}

      describe 'basics' do
        its(:name){should == 'Buenos Aires'}
        its(:long_name){should == 'Autonomous City of Buenos Aires'}
        its(:tz_offset){should == TZOffset.parse('GMT-3')}
      end

      describe 'links' do
        its(:country){should be_an Entity}
        its(:'country.name'){should == 'Argentina'}
        its(:country){should_not be_loaded}

        xit 'should parse leaders' do
          leaders = city.leaders
          expect(leaders).to be_a(Hash)
          expect(leaders.keys).to contain_exactly('Chief of Government', 'Senators')
          expect(leaders['Chief of Government'].to_s).to eq 'Horacio Rodríguez Larreta'
          expect(leaders['Senators'].map(&:to_s)).to eq ['Gabriela Michetti', 'Diego Santilli', 'Pino Solanas']
        end
      end

      describe 'measures' do
        its(:area){should == Reality::Measure(203, 'km²')}
        its(:population){should == Reality::Measure(2_890_151, 'person')}
        its(:population_metro){should == Reality::Measure(12_741_364, 'person')}
      end

      xdescribe 'geo' do
        its(:coord){should == Reality::Geo::Coord.from_dms([34,35,58,'S'], [58,22,54,'W'])}
      end
    end
  end
end
