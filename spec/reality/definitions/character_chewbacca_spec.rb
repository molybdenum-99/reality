module Reality
  describe 'Chewbacca' do
    before(:all){
      # parsed only once - faster tests
      VCR.use_cassette('Character-Chewbacca'){
        @character = Reality::Entity('Chewbacca')
      }
    }
    subject(:character){@character}

    its(:'species.name'){should == 'Wookiee'}
  end
end
