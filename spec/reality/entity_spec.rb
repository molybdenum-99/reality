module Reality
  describe Entity do
    let(:observations) {
      [
        Observation.new(:_source, Link.new(:wikipedia, 'Johnny Depp')),
        Observation.new(:name, 'John'),
        Observation.new(:age, 21),
        Observation.new(:father, Link.new(:wikipedia, 'Jeff Bridges'))
      ]
    }

    subject(:entity) { Entity.new(observations) }

    describe '#initialize' do
      its(:observations) { are_expected.to eq observations }
    end

    describe '.find' do
      context 'known datasource' do
        context 'entity found' do
          let(:wikipedia) { instance_double('Reality::DataSources::Base') }

          before {
            expect(Reality).to receive(:data_sources).and_return(wikipedia: wikipedia)
            expect(wikipedia).to receive(:find).with('Argentina').and_return(observations)
          }

          subject { Entity.find(wikipedia: 'Argentina') }

          its(:observations) { are_expected.to eq observations }
        end

        context 'entity not found' do
        end
      end

      context 'unknown datasource' do
      end
    end

    describe '#[]' do
      its([:age]) { is_expected.to eq [Observation.new(:age, 21)] }
    end

    context 'sources' do
      # loaded source
      # not loaded source
    end

    describe '#inspect' do
      its(:inspect) { is_expected.to eq '#<Reality::Entity wikipedia:Johnny Depp>' }
      # TODO: inspect including other sources
    end

    describe '#describe' do # (sic!)
      its(:describe) {
        is_expected.to eq %Q{
          |#<Reality::Entity wikipedia:Johnny Depp>
          |   name: John
          |    age: 21
          | father: wikipedia:Jeff Bridges
        }.unindent
      }
    end

    describe '#load' do
      let(:observations) {
        [
          Observation.new(:_source, Link.new(:wikipedia, 'Johnny Depp')),
          Observation.new(:name, 'John'),
          Observation.new(:_source, Link.new(:wikidata, 'Q37175'))
        ]
      }
      let(:observations_from_wikidata) {
        [
          Observation.new(:age, 21),
          Observation.new(:father, Link.new(:wikipedia, 'Jeff Bridges'))
        ]
      }

      let(:wikidata) { instance_double('Reality::DataSources::Base') }

      before {
        expect(Reality).to receive(:data_sources).and_return(wikidata: wikidata)
        expect(wikidata).to receive(:find).with('Q37175')
          .and_return(observations_from_wikidata)
      }
      subject { entity.load(:wikidata) }

      it { is_expected.to be_an Entity }
      its(:observations) { are_expected.to match_array(observations + observations_from_wikidata) }
    end
  end
end

