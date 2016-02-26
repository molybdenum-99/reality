module Reality
  describe Continent, 'Europe' do
    before(:all){
      # parsed only once - faster tests
      VCR.use_cassette('Continent-Europe'){
        @continent = Reality::Entity.new('Europe', load: true) 
      }
    }
    subject(:continent){@continent}

    it{should be_a Continent}
    its(:area){should == Reality::Measure.new(10_180_000, 'km²')}
  end
end
