module Reality
  describe :city do
    describe 'existing city' do
      before(:all){
        VCR.use_cassette('city-Buenos-Aires'){
          @city = Reality.city('Buenos-Aires') # parsed only once - faster tests
        }
      }

      subject(:city){@city}

      it{should be_a(Reality::City)}

      describe 'basics' do
        its(:name){should == 'Buenos Aires'}
        its(:long_name){should == 'Autonomous City of Buenos Aires'}
        its(:utc_offset){should == -3}
      end

      describe 'links' do
        its(:'country.to_s'){should == 'Argentina'}

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
    end
  end
end
