require 'reality/data_sources/open_weather_map'

module Reality
  describe DataSources::OpenWeatherMap do
    let(:client) { described_class.new(ENV['OPEN_WEATHER_MAP_APPID']) }

    # TODO: DataSource#timed?

    context 'default' do
      before {
        stub_request(:get, %r{api\.openweathermap\.org/data/2\.5/weather})
          .to_return(body: File.read('spec/fixtures/open_weather_map/current.json'))
      }

      subject(:response) { client.find([50.004444, 36.231389]) }

      it { is_expected.not_to be_empty }
      it { is_expected.to all be_a Observation }

      context 'particular properties' do
        subject { ->(name) { response.detect { |o| o.name == name }.value } }

        its([:_source]) { is_expected.to eq Link.new(:open_weather_map, '50.0,36.23') }
        its([:temperature]) { is_expected.to eq Measure['°C'].new(6) }
      end
    end

    context 'with period explicitly set' do
      before { Timecop.freeze('2017-03-26') }

      context 'reachable period' do
        before {
          stub_request(:get, %r{api\.openweathermap\.org/data/2\.5/forecast})
            .to_return(body: File.read('spec/fixtures/open_weather_map/forecast.json'))
        }

        subject(:response) { client.find([50.004444, 36.231389], at: Date.parse('2017-03-28')) }

        context 'observations' do
          subject { response.select { |o| o.name == :temperature } }

          its(:count) { is_expected.to eq 36 }
          its_map(:time) { are_expected.to all match Time.at(1490529600)..Time.at(1490907600) }
          its_map(:name) { are_expected.to all eq :temperature }
          its_map(:value) { are_expected.to all be_covered_by(Measure['°C'].new(-2)..Measure['°C'].new(12)) }
        end
      end

      xcontext 'unreachable period' do
        subject(:response) { client.find([50.004444, 36.231389], at: Date.parse('2017-04-28')) }

        it { is_expected.to be_empty }
      end
    end

    context 'with wrong key' do
    end
  end
end
