module Reality
  describe Dictionaries, :cities_by_country, :vcr do
    specify 'Ukraine' do
      list = Dictionaries.cities_by_country('Ukraine')
      expect(list).to be_an List
      expect(list.map(&:name)).to include('Kyiv', 'Kharkiv', 'Dnipropetrovsk')
    end

    specify 'Italy' do
      list = Dictionaries.cities_by_country('Italy')
      expect(list).to be_an List
      expect(list.map(&:name)).to include('Naples', 'Rome', 'Turin')
    end

    specify 'Vietnam' do
      list = Dictionaries.cities_by_country('Vietnam')
      expect(list).to be_an List
      expect(list.map(&:name)).to include('Ha Noi', 'Ho Chi Minh City', 'Hai Phong')
    end

    specify 'USA' do
      list = Dictionaries.cities_by_country('United States')
      expect(list).to be_an List
      expect(list.map(&:name)).to include('New York', 'Los Angeles', 'Philadelphia')
    end

    specify 'Bolivia' do
      list = Dictionaries.cities_by_country('Bolivia')
      expect(list).to be_an List
      expect(list.map(&:name)).to include('Santa Cruz de la Sierra', 'Punata', 'Sucre')
    end
  end
end
