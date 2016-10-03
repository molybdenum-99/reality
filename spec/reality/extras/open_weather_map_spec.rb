module Reality
  #module Extras::OpenWeatherMap
    #describe 'basics' do
      #let(:response){JSON.parse(File.read('spec/fixtures/openweathermap.json'))}

      #describe Weather do
        #subject{Weather.from_hash(response)}
        #it{should be_kind_of(Hashie::Mash)}
        #its(:humidity){should == Reality::Measure.new(100, '%')}
        #its(:temperature){should == Reality::Measure.new(6.46, '°C')}
        #its(:temp){should == Reality::Measure.new(6.46, '°C')}
        #its(:sky){should == 'Clear'}
        #its(:inspect){should == '#<Reality::Weather(6°C, Clear)>'}
        #its(:'to_h.keys'){should contain_exactly(:humidity, :temperature, :sky, :pressure)}
      #end

      #describe CoordWeather do
        #let(:coord){Geo::Coord.new(50, 36.25)}

        #before{
          #coord.extend CoordWeather
        #}

        #it 'extracts weather!' do
          #expect(OpenWeather::Current).to receive(:geocode).
            #with(coord.lat.to_f, coord.lng.to_f, hash_including(:APPID, units: "metric")).
            #and_return(response)

          #weather = coord.weather
          #expect(weather).to be_a Weather
          #expect(weather).to eq Weather.from_hash(response)
        #end
      #end
    #end
  #end
end
