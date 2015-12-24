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

        # TODO: "Spanish language" and "Argentine peso", in fact
        #   or even Language(Spanish), but Currency(Argentine peso | $)
        it 'should have languages' do
          expect(country.languages.map(&:to_s)).to eq ['Spanish']
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
        its(:area){should == Reality::Measure(2780400, 'km²')}
        its(:population){should == Reality::Measure(43417000, 'person')}
      end

      describe 'external data', :vcr do
        its(:continent){should == 'South America'}
      end

      describe 'geo' do
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
          calling_code: '+54',
          utc_offset: -3,
          capital: 'Buenos Aires',
          languages: ['Spanish language'],
          currency: 'Argentine peso',
          leaders: {
              'President' => 'Mauricio Macri',
              'Vice-president' => 'Gabriela Michetti'
            },
          area: 2780400,
          population: 43417000
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
