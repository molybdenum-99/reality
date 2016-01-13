module Reality
  module Geo
    describe Point do
      describe :initialize do
        subject(:point){Point.new(100, 200)}
        it{should have_attributes(
          lat: Rational(100),
          latitude: Rational(100),
          lng: Rational(200),
          longitude: Rational(200)
        )}
      end

      describe :== do
        subject(:point){Point.new(100, 200)}
        let(:equal){Point.new(100, 200)}
        let(:not_equal){Point.new(110, 200)}

        it{should == equal}
        it{should_not == not_equal}
      end
      
      describe :from_dms do
        context 'with degs sign' do
          subject(:point){Point.from_dms([38, 53, 23], [-77, 00, 32])}
          let(:blueprint){Point.new(38.8897, -77.0089)}
          its(:'lat.to_f'){should be_within(0.01).of(blueprint.lat.to_f)}
          its(:'lng.to_f'){should be_within(0.01).of(blueprint.lng.to_f)}
        end

        context 'with direction' do
          subject(:point){Point.from_dms([38, 53, 23, 'N'], [77, 00, 32, 'W'])}
          let(:blueprint){Point.new(38.8897, -77.0089)}
          its(:'lat.to_f'){should be_within(0.01).of(blueprint.lat.to_f)}
          its(:'lng.to_f'){should be_within(0.01).of(blueprint.lng.to_f)}
        end
      end

      describe :to_dms do
        subject(:point){Point.new(38.8897, -77.0089)}

        it 'converts with direction' do
          lat = point.lat_dms
          d, m, s, dir = *lat
          expect(d).to eq 38
          expect(m).to eq 53
          expect(s).to within(0.1).of(23)
          expect(dir).to eq 'N'

          lng = point.lng_dms
          d, m, s, dir = *lng
          expect(d).to eq 77
          expect(m).to eq 00
          expect(s).to within(0.1).of(32)
          expect(dir).to eq 'W'
        end

        it 'converts with sign' do
          lat = point.lat_dms(false)
          d, m, s, dir = *lat
          expect(d).to eq 38
          expect(m).to eq 53
          expect(s).to within(0.1).of(23)
          expect(dir).to be_nil

          lng = point.lng_dms(false)
          d, m, s, dir = *lng
          expect(d).to eq -77
          expect(m).to eq 00
          expect(s).to within(0.1).of(32)
          expect(dir).to be_nil
        end
      end

      describe :inspect do
      end

      describe :ll do
      end
    end
  end
end
