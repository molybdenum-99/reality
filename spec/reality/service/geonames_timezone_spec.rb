require 'reality/service/geonames_timezone'

module Reality
  module Service
    describe GeonamesTimezone do
      context 'instance' do
        let(:entity) { double(name: 'Vienna', coord: Geo::Coord.new(47.01, 10.2)) }
        subject(:service) { described_class.new(entity, ENV['GEONAMES_USERNAME']) }

        its(:inspect) {
          is_expected.to eq '#<Reality::Service::GeonamesTimezone(Vienna): name>'
        }

        describe '#name', :vcr do
          subject { service.name }

          it { is_expected.to be_a TZInfo::Timezone }
          its(:name) { is_expected.to eq 'Europe/Vienna' }
        end
      end
    end
  end
end
