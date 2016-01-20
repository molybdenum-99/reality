module Reality
  describe Entity, :vcr do
    let(:wiki_page){double(title: 'Paris, France', infobox: double(name: 'Infobox country'))}

    let(:wikipedia){double}
    before{
      allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
    }
    
    describe :initialize do
      context 'without preload' do
        subject{Entity.new('Paris')}
        it{should_not be_loaded}
        its(:inspect){should == "#<Reality::Entity?(Paris)>"}
      end

      context 'with preload' do
        subject{Entity.new('Paris', wiki_page)}
        it{should be_loaded}
        its(:inspect){should == "#<Reality::Entity(Paris, France)>"}
      end
    end

    describe :load! do
      context 'abstract entity' do
        subject(:entity){Entity.new('Paris')}
        it 'should load page' do
          expect(Infoboxer.wikipedia).to receive(:get).
            with('Paris').and_return(wiki_page)

          entity.load!

          expect(entity).to be_loaded
        end
      end

      context 'concrete class' do
        let(:klass){
          Class.new(Entity){
            infobox_name 'Infobox settlement'
          }
        }
        let(:entity){klass.new('Paris')}
        
        context 'when page with expected infobox fetched' do
          let(:wiki_page){double(title: 'Paris', infobox: double(name: 'Infobox settlement'))}
          it 'should be loaded successfully' do
            allow(wikipedia).to receive(:get).and_return(wiki_page)

            expect{entity.load!}.not_to raise_error
          end
        end

        context 'when page with unexpected infobox fetched' do
          let(:wiki_page){double(title: 'Paris', infobox: double(name: 'Infobox country'))}
          it 'should be loaded successfully' do
            allow(wikipedia).to receive(:get).and_return(wiki_page)

            expect{entity.load!}.to raise_error(EntityTypeError, /country/)
          end
        end

        context 'when page with no infobox fetched' do
        end
      end
    end

    describe '::load' do
      context 'abstract entity' do
        it 'should load page' do
          expect(Infoboxer.wikipedia).to receive(:get).
            with('Paris').and_return(wiki_page)

          entity =  Entity.load('Paris')

          expect(entity).to be_loaded
        end
      end

      context 'concrete class' do
        let(:klass){
          Class.new(Entity){
            infobox_name 'Infobox settlement'
          }
        }
        
        context 'when page with expected infobox fetched' do
          let(:wiki_page){double(title: 'Paris', infobox: double(name: 'Infobox settlement'))}
          it 'should be loaded successfully' do
            allow(wikipedia).to receive(:get).and_return(wiki_page)

            entity = klass.load('Paris')
            expect(entity.class).to eq klass
          end
        end

        context 'when page with unexpected infobox fetched' do
          let(:wiki_page){double(title: 'Paris', infobox: double(name: 'Infobox country'))}
          it 'should be loaded successfully' do
            allow(wikipedia).to receive(:get).and_return(wiki_page)

            entity = klass.load('Paris')
            expect(entity).to be_nil
          end
        end

        context 'when page with no infobox fetched' do
        end
      end
    end

    describe :wikipedia_page do
      subject(:entity){Entity.new('Paris')}

      it 'should load page on demand' do
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Paris').and_return(wiki_page)

        expect(entity.wikipedia_page).to eq wiki_page
      end
    end

  end
end
