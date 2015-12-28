module Reality
  describe Country, 'list' do
    before(:all){ # caching!
      VCR.use_cassette(:by_continents){Country.by_continents}
    } 

    describe 'array-ish methods', :vcr do
      subject(:list){Reality.countries}

      let(:country_names){Country.by_continents.keys.sort}

      specify :count do
        expect(Reality.wp).not_to receive(:get)
        expect(list.count).to eq country_names.count
      end
      
      specify :first do
        expect(Reality.wp).to receive(:get).
          with(country_names.first).
          and_return([double])

        expect(list.first).to be_kind_of(Country)

        expect(Reality.wp).to receive(:get).
          with(*country_names.first(5)).
          and_return([double] * 5)

        expect(list.first(5)).to all be_kind_of(Country)
      end

      specify :last do
        expect(Reality.wp).to receive(:get).
          with(country_names.last).
          and_return([double])

        expect(list.last).to be_kind_of(Country)

        expect(Reality.wp).to receive(:get).
          with(*country_names.last(5)).
          and_return([double] * 5)

        expect(list.last(5)).to all be_kind_of(Country)
      end

      specify :sample do
        expect(Reality.wp).to receive(:get).
          with(instance_of(String), instance_of(String)).
          and_return([double] * 2)

        expect(list.sample(2)).to all be_kind_of(Country)
      end

      specify :to_a do
        expect(Reality.wp).to receive(:get).
          with(*country_names).
          and_return([double] * country_names.count)

        expect(list.to_a).to all be_kind_of(Country)
      end
    end

    describe 'filtering' do
    end
  end
end
