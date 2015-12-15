module Reality
  describe :country, :vcr do
    describe 'existing country' do
      subject(:country){Reality.country('Argentina')}

      it{should be_a(Reality::Country)}

      describe 'basics' do
        its(:name){should == 'Argentina'}
        its(:long_name){should == 'Argentine Republic'}
      end

      describe 'links' do
        its(:'capital.to_s'){should == 'Buenos Aires'}
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
