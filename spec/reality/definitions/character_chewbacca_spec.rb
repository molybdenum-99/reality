module Reality
  describe Character, 'Chewbacca' do
    before(:all){
      # parsed only once - faster tests
      VCR.use_cassette('Character-Chewbacca'){
        @character = Reality::Entity('Chewbacca') 
      }
    }
    subject(:character){@character}

    it{should be_a Character}
    its(:'species.name'){should == 'Wookiee'}
  end
end
