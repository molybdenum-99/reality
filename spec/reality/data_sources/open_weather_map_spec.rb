require 'reality/data_sources/wikidata'

module Reality
  describe DataSources::OpenWeatherMap do
    let(:client) { described_class.new(ENV['OPEN_WEATHER_MAP_APPID']) }

    subject(:response) { client.get(10, 20) }

    context 'particular properties' do
      its([:temperature]) { is_expected.to eq 20 }
    end

    # TODO: check same obs for diff periods
    # TODO: check get with period specified
    #   how to know DS can do that?

  end
end
