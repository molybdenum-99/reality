require 'reality/observation'
require 'reality/observations'

module Reality
  describe Observations do
    let(:observations_list) {
      [
        Observation.new(_index: Date.new(2016,5,1), _type: 'Weather', temp: 30, humidity: 23),
        Observation.new(_index: Date.new(2016,5,2), _type: 'Weather', temp: 18),
        Observation.new(_index: Date.new(2016,5,3), _type: 'Weather', temp: 30, humidity: 23, sky: 'clear')
      ]
    }
    subject(:observations) { described_class.new(*observations_list) }

    describe '#initialize' do
      its(:size) { is_expected.to eq 3 }
      its(:variables) { is_expected.to eq %i[temp humidity sky] }
      its(:type) { is_expected.to eq 'Weather' }

      its(:'observations.count') { is_expected.to eq 3 }
      its(:observations) { is_expected.to all be_an Observation }
      its(:observations) { is_expected.to all satisfy { |o| o.variables == subject.variables } }

      context 'observations type check' do
        let(:observations_list) {
          [
            Observation.new(_index: Date.new(2016,5,1), _type: 'Weather', temp: 30, humidity: 23),
            Observation.new(_index: Date.new(2016,5,2), _type: 'Demographics', population: 300_000),
          ]
        }

        its_call { is_expected.to raise_error(ArgumentError, /Weather, Demographics/) }
      end

      context 'observations index type check' do
        let(:observations_list) {
          [
            Observation.new(_index: Date.new(2016,5,1), _type: 'Weather', temp: 30, humidity: 23),
            Observation.new(_index: Time.new(2016,5,1), _type: 'Weather', temp: 18),
          ]
        }

        its_call { is_expected.to raise_error(ArgumentError, /Date, Time/) }
      end

      context 'index unicality check' do
        let(:observations_list) {
          [
            Observation.new(_index: Date.new(2016,5,1), _type: 'Weather', temp: 30, humidity: 23),
            Observation.new(_index: Date.new(2016,5,1), _type: 'Weather', temp: 18),
          ]
        }

        its_call { is_expected.to raise_error(ArgumentError, /non-unique indexes.*2016-05-01/) }
      end
    end

    describe '#inspect' do
      its(:inspect) { is_expected.to eq "#<Reality::Observations(Weather): [temp, humidity, sky] x 3>" }
    end

    context 'access to single observation' do
      context 'by num' do
        its([1]) { is_expected.to eq subject.observations[1] }
      end

      context 'by index' do
        it { expect(subject.at(Date.new(2016,5,2))).to eq subject.observations[1] }
      end

      context 'special accessors' do
        describe '#first' do
          its(:first) { is_expected.to eq subject.observations.first }
        end

        describe '#last' do
          its(:last) { is_expected.to eq subject.observations.last }
        end

        describe '#today' do
          subject { observations.today }

          context 'with date index' do
            let(:observations_list) {
              [
                Observation.new(_index: Date.new(2016,5,1), _type: 'Weather', temp: 30, humidity: 23),
                Observation.new(_index: Date.new(2016,5,2), _type: 'Weather', temp: 18),
                Observation.new(_index: Date.new(2016,5,3), _type: 'Weather', temp: 30, humidity: 23, sky: 'clear'),
                Observation.new(_index: Date.today, _type: 'Weather', temp: 40)
              ]
            }

            it { is_expected.to eq observations.observations.last }
          end

          context 'with non-date index' do
            let(:observations_list) {
              [
                Observation.new(_index: 1, _type: 'Weather', temp: 30, humidity: 23),
                Observation.new(_index: 2, _type: 'Weather', temp: 18),
                Observation.new(_index: 3, _type: 'Weather', temp: 30, humidity: 23, sky: 'clear')
              ]
            }

            its_call { is_expected.to raise_error(/non-Date index/) }
          end
        end
      end
    end

    context 'enumerable behavior' do
      its(:'each.to_a') { is_expected.to eq subject.observations }
    end

    context '#index' do
      its(:index) { is_expected.to eq observations_list.map(&:index) }
    end
  end
end
