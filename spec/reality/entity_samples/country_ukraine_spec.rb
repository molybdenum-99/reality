module Reality
  describe Entity, 'samples' do
    describe 'Country: Ukraine' do
      before(:all){
        # parsed only once - faster tests
        VCR.use_cassette('Country-Ukraine'){
          @country = Reality::Entity.new('Ukraine', load: true) 
        }
      }
      subject(:country){@country}
      its(:entity_class){should == Reality::Country}

      describe 'measures' do
        its(:area){should == Reality::Measure(603_500, 'km²')}
      end
    end
  end
end
