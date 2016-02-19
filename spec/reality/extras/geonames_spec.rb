module Reality
  module Extras::Geonames
    describe CoordTimezone do
      # Chiang Mai
      let(:coord){Geo::Coord.new(18.795278, 98.998611)}

      before{
        coord.extend CoordTimezone
      }

      it 'extracts tz' do
        tz = VCR.use_cassette('Timezone-Geonames'){
          coord.timezone
        }

        expect(tz).to be_a TZInfo::Timezone
        expect(tz.identifier).to eq 'Asia/Bangkok'
      end
    end
  end
end
