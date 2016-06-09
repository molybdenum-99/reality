module Reality
  describe Entity, 'samples' do
    describe 'Country: Argentina' do
      before(:all){
        # parsed only once - faster tests
        VCR.use_cassette('Country-Argentina'){
          @country = Reality::Entity('Argentina')
        }
      }

      subject(:country){@country}
      its(:wikipedia_type){should == Reality::Country}

      describe 'basics' do
        its(:name){should == 'Argentina'}
        its(:long_name){should == 'Argentine Republic'}

        its(:iso2_code){should == 'AR'}
        its(:iso3_code){should == 'ARG'}
        its(:tld){should == '.ar'}
        its(:calling_code){should == '+54'}
        its(:tz_offset){should == TZOffset.parse('GMT-3')}
      end

      describe 'measures' do
        its(:area){should == Reality::Measure(2_780_400, 'km²')}
        its(:population){should == Reality::Measure(43_417_000, 'person')}
        its(:gdp_ppp){should == Reality::Measure(964_279_000_000, '$')}
        its(:gdp_nominal){should == Reality::Measure(537_659_972_702, '$')}
      end

      describe 'geo' do
        its(:coord){should == Geo::Coord.from_dms([34,'S'], [64,'W'])}
      end

      describe 'links' do
        its(:capital){should be_an Entity}
        its(:'capital.name'){should == 'Buenos Aires'}
        its(:currency){should be_an Entity}
        its(:'currency.name'){should == 'peso'}

        its(:'continent.name'){should == 'South America'}

        xit 'parses organizations' do
          orgs = country.organizations
          expect(orgs).to all be_an Entity
          expect(orgs.map(&:name)).to contain_exactly \
            'G15', 'G20', 'Mercosur', 'Union of South American Nations', 'United Nations'
        end

        it 'parses neighbours' do
          neighs = country.neighbours
          expect(neighs).to all be_an Entity
          expect(neighs.map(&:name)).to contain_exactly \
            'Bolivia', 'Brazil', 'Chile', 'Paraguay', 'Uruguay'
        end

        it 'parses languages' do
        end

        it 'parses country leaders' do
        end
      end
    end
  end
end
