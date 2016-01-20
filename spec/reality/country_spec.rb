module Reality
  describe :country do
    describe 'existing country' do
      before(:all){
        VCR.use_cassette('country-Argentina'){
          @country = Reality.country('Argentina') # parsed only once - faster tests
        }
      }
      
      subject(:country){@country}

      it{should be_a(Reality::Country)}

      describe 'basics' do
        its(:name){should == 'Argentina'}
        its(:long_name){should == 'Argentine Republic'}
        
        its(:tld){should == '.ar'}
        its(:calling_code){should == '+54'}
        its(:utc_offset){should == -3}
      end

      describe 'links' do
        its(:'capital.to_s'){should == 'Buenos Aires'}
        its(:capital){should be_a(City)}
        its(:capital){should_not be_loaded}

        # TODO: "Spanish language" and "Argentine peso", in fact
        #   or even Language(Spanish), but Currency(Argentine peso | $)
        it 'should have languages' do
          expect(country.languages['Official'].first.to_s).to eq 'Spanish'
        end
        
        its(:'currency.to_s'){should == 'Peso'}

        it 'should parse leaders' do
          leaders = country.leaders
          expect(leaders).to be_a(Hash)
          expect(leaders.keys).to contain_exactly('President', 'Vice-president')
          expect(leaders['President'].to_s).to eq 'Mauricio Macri'
          expect(leaders['Vice-president'].to_s).to eq 'Gabriela Michetti'
        end
      end

      describe 'measures' do
        its(:area){should == Reality::Measure(2_780_400, 'km²')}
        its(:population){should == Reality::Measure(43_417_000, 'person')}
        its(:gdp_ppp){should == Reality::Measure(964_279_000_000, '$')}
        its(:gdp_nominal){should == Reality::Measure(578_705_000_000, '$')}
      end

      describe 'external data', :vcr do
        its(:continent){should == 'South America'}
        its(:organizations){should contain_exactly \
          'G15', 'G20', 'Mercosur', 'Union of South American Nations', 'United Nations'
        }
        it{should be_member_of 'UN'}
        it{should_not be_member_of 'CIS'}
      end

      describe 'geo' do
        its(:coord){should == Geo::Coord.from_dms([34,36,'S'], [58,23,'W'])}
      end

      describe 'media' do
      end

      describe 'service' do
        its(:to_s){should == 'Argentina'}
        its(:inspect){should == '#<Reality::Country(Argentina)>'}
        its(:to_h){should == {
          continent: 'South America',
          name: 'Argentina',
          long_name: 'Argentine Republic',
          tld: '.ar',
          tlds: ['.ar'],
          calling_code: '+54',
          utc_offset: -3,
          capital: 'Buenos Aires',
          languages: {'Official' => ['Spanish language']},
          currency: 'Argentine peso',
          leaders: {
              'President' => 'Mauricio Macri',
              'Vice-president' => 'Gabriela Michetti'
            },
          area: 2780400,
          organizations: ["G15", "G20", "Mercosur", "Union of South American Nations", "United Nations"],
          population: 43417000,
          gdp_ppp: 964_279_000_000,
          gdp_nominal: 578_705_000_000
        }}
      end
    end

    describe 'not a country', :vcr do
      context 'existing non-country article' do
        subject{Reality.country('Narnia')}

        it{should be_nil}
      end

      context 'non-existing article' do
        subject{Reality.country('It is definitely not existing')}

        it{should be_nil}
      end
    end
  end
end
