module Reality
  describe EntityList do
    describe :initialize do
      it 'works' do
        list = EntityList.new('Argentina', 'Bolivia', 'Chile')
        expect(list.count).to eq 3
      end
    end

    describe :all do
      def make_page(name)
        double(title: name, infobox: double(name: 'Infobox country'))
      end

      let(:list){EntityList.new('Argentina', 'Bolivia', 'Chile')}

      let(:wikipedia){double}
      before{
        allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
      }
      
      it 'fetches everything at once from Infoboxer, than gradually from Wikidata' do
        expect(Infoboxer.wikipedia).to receive(:get).
          with('Argentina', 'Bolivia', 'Chile').
          and_return([make_page('Argentina'), make_page('Bolivia'), make_page('Chile')])

        expect(Wikidata::Entity).to receive(:fetch).
          with('Argentina').and_return([double]).ordered
        expect(Wikidata::Entity).to receive(:fetch).
          with('Bolivia').and_return([double]).ordered
        expect(Wikidata::Entity).to receive(:fetch).
          with('Chile').and_return([double]).ordered

        countries = list.all
        expect(countries.count).to eq 3
        expect(countries).to all be_an(Entity)
        expect(countries).to all be_loaded
      end
    end

    describe :first do
    end

    describe :last do
    end

    describe :sample do
    end

    describe :inspect do
    end

    describe 'filtering' do
    end
  end
end
