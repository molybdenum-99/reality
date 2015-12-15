module Reality
  describe :country, :vcr do
    describe 'existing country' do
      subject(:country){Reality.country('Argentina')}

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

      end

      describe 'measures' do
      end

      describe 'geo' do
      end

      describe 'media' do
      end

      describe 'service' do
        its(:to_s){should == 'Argentina'}
        its(:inspect){should == '#<Reality::Country(Argentina)>'}
      end
    end

    describe 'non-existing country' do
      subject{Reality.country('Narnia')}

      it{should be_nil}
    end
  end
end
