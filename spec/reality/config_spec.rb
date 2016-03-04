require 'reality/config'

module Reality
  describe Config do
    let(:config){Config.new}
    
    describe :register do
      before{
        config.register('keys', 'openweathermap', desc: 'OpenWeatherMap access key')
      }
      subject{config}
      its(:keys){should include(['keys', 'openweathermap'])}
    end

    describe :load do
      context 'from string' do
        before{config.load({'keys' => {'openstreetmap' => 'foo'}}.to_yaml)}
        it 'should be loaded' do
          expect(config.data['keys']['openstreetmap']).to eq 'foo'
        end
      end

      context 'from file' do
        before{config.load('spec/fixtures/config.yaml')}
        it 'should be loaded' do
          expect(config.data['keys']['openstreetmap']).to eq 'bar'
        end
      end
    end

    describe :fetch do
      before{
        config.register('keys', 'openweathermap', desc: 'OpenWeatherMap access key')
      }
      context 'when not loaded' do
        it 'should fail' do
          expect{config.fetch('keys', 'openweathermap')}.to \
            raise_error /openweathermap.+OpenWeatherMap access key/
        end
      end
      
      context 'when loaded: registered key' do
      end

      context 'when loaded: unregistered key' do
      end
    end
  end
end
