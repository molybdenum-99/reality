module Reality
  describe Weather do
    before do
      OpenWeather::Current.any_instance.stub(:retrive) do
        {"coord"=>{"lon"=>-58.38, "lat"=>-34.61},
         "weather"=>[{"id"=>804, "main"=>"Clouds", "description"=>"overcast clouds", "icon"=>"04d"}],
         "base"=>"cmc stations", "main"=>{"temp"=>295.95, "pressure"=>1016, "humidity"=>77, "temp_min"=>294.15, "temp_max"=>297.04},
         "wind"=>{"speed"=>6.7, "deg"=>170}, "clouds"=>{"all"=>90}, "dt"=>1452344697,
         "sys"=>{"type"=>1, "id"=>4699, "message"=>0.003, "country"=>"AR", "sunrise"=>1452329460, "sunset"=>1452381007},
         "id"=>6693229, "name"=>"San Nicolas", "cod"=>200}
      end
    end

    context 'when included to a Country' do
      let(:entity) { Country.new(1) }

      before { entity.stub(:name) { 'Argentina' } }

      describe '#weather' do
        subject { entity.weather }

        it 'returns general description' do
          expect(subject).to eq('Clouds')
        end
      end

      describe '#temperature' do
        subject { entity.temperature }

        it 'returns number' do
          expect(subject).to eq(295.95)
        end
      end

      describe '#humidity' do
        subject { entity.humidity }

        it 'returns number' do
          expect(subject).to eq(77)
        end
      end

      describe '#pressure' do
        subject { entity.pressure }

        it 'returns number' do
          expect(subject).to eq(1016)
        end
      end
    end
  end
end
