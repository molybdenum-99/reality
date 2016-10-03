require 'reality/service/open_weather_map'

module Reality
  module Service
    describe OpenWeatherMap do
      context 'injecting' do
        context 'when entity has coordinates' do
        end

        context 'when entity has no coordinates' do
        end
      end

      context 'config check' do
      end

      context 'instance' do
        let(:entity) { double(coord: Geo::Coord.new(1, 2)) }
        subject(:service) { described_class.new(entity, ENV['OPEN_WEATHER_MAP_APPID']) }

        describe '#current', :vcr do
          subject { service.current }

          it { is_expected.to be_an Observation }
          its(:index) { is_expected.to be_a Time }
          its(:type) { is_expected.to eq 'Weather' }
          its(:variables) { is_expected.to include(*%i[temp humidity]) }
        end

        describe '#forecast', :vcr do
          subject { service.forecast }

          it { is_expected.to be_an Observations }
          its(:'index.first') { is_expected.to be_a Time }
          its(:type) { is_expected.to eq 'Weather' }
          its(:variables) { is_expected.to include(*%i[temp humidity]) }
        end
      end
    end
  end
end
