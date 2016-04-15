module Reality
  describe Continent, 'South America' do
    before(:all){
      # parsed only once - faster tests
      VCR.use_cassette('Continent-South-America'){
        @continent = Reality::Entity('South America') 
      }
    }
    subject(:continent){@continent}

    it{should be_a Continent}
    its(:area){should == Reality::Measure.new(17_840_000, 'km²')}
  end
end
