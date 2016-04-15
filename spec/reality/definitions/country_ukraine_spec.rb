module Reality
  describe Entity, 'samples' do
    describe 'Country: Ukraine' do
      before(:all){
        # parsed only once - faster tests
        VCR.use_cassette('Country-Ukraine'){
          @country = Reality::Entity('Ukraine') 
        }
      }
      subject(:country){@country}
      its(:wikipedia_type){should == Reality::Country}

      describe 'measures' do
        its(:area){should == Reality::Measure(603_500, 'km²')}
      end
    end
  end
end
