module Reality
  describe Entity do
    def var(name, *observations)
      Variable.new(name, observations.map(&method(:obs)))
    end

    def obs(*args)
      return args.first if args.first.is_a?(Observation)
      Observation.new(Date.parse(args[0]), args[1], source: args[2])
    end

    # Well, it is not THAT useful specs, but they help to design how it works at all.
    describe '#initialize' do
      context 'with variables' do
        let(:variables) {
          [
            var(:temperature, obs('2016-05-01', 5)),
            var(:pressure, obs('2016-05-01', 10))
          ]
        }

        subject { described_class.new(variables: variables) }

        its(:variables) { are_expected.to eq variables }
      end

      context 'with sources' do
        let(:sources) { {wikipedia: 'Kharkiv', wikidata: 'Q42308'} }

        subject { described_class.new(sources: sources) }

        its(:sources) { are_expected.to eq sources }
      end
    end

    describe '#screenname' do
      context 'variable-based'
      context 'source-based'
      context 'none found'
    end

    describe '#<variable>' do
      let(:variables) {
        [
          var(:temperature, obs('2016-05-01', 15, :wikipedia), obs('2016-06-01', 25, :wikidata), obs('2016-07-01', 24, :wikipedia)),
        ]
      }

      let(:entity) { described_class.new(variables: variables) }

      context 'simplest' do
        subject { entity.temperature }

        it { is_expected.to eq variables.first }
      end

      context 'source specification' do
        subject { entity.temperature(:wikidata) }

        it { is_expected.to eq var(:temperature, obs('2016-06-01', 25, :wikidata)) }
      end

      context 'timestamp specification'

      context 'non-existent variable' do
        subject { entity.precipation }

        it { is_expected.to be_nil }
      end
    end

    describe '#update' do
      let(:variables) {
        [
          var(:temperature, obs('2016-05-01', 15, :wikipedia), obs('2016-06-01', 25, :wikidata), obs('2016-07-01', 24, :wikipedia)),
        ]
      }
      let(:new_variables) {
        [
          var(:temperature, obs('2016-04-01', 15, :wikipedia)),
          var(:pressure, obs('2016-05-01', 222))
        ]
      }

      subject(:entity) { described_class.new(variables: variables) }

      before { entity.update(new_variables) }

      its(:temperature) { is_expected
        .to eq var(:temperature, obs('2016-04-01', 15, :wikipedia), obs('2016-05-01', 15, :wikipedia), obs('2016-06-01', 25, :wikidata), obs('2016-07-01', 24, :wikipedia))
      }

      its(:pressure) { is_expected.to eq var(:pressure, obs('2016-05-01', 222)) }
    end

    describe '#load'

    describe '.load'
  end
end

__END__
    describe '#initialize' do
      context 'when created from name only' do
        subject { described_class.new('Kharkiv') }
        its(:name) { is_expected.to eq 'Kharkiv' }
        its(:inspect) { is_expected.to eq '#<Reality::Entity Kharkiv>' }
      end

      context 'when created from data sources' do
        subject { described_class.new(wikipedia: 'Kharkiv', wikidata: 'Q242') }
        its(:name) { is_expected.to be_nil }
        its(:inspect) { is_expected.to eq '#<Reality::Entity (wikipedia: Kharkiv?, wikidata: Q242?)>' }
      end

      context 'when created from name & data sources' do
        subject { described_class.new('Kharkiv', wikipedia: 'Kharkiv', wikidata: 'Q242') }
        its(:name) { is_expected.to eq 'Kharkiv' }
        its(:inspect) { is_expected.to eq '#<Reality::Entity Kharkiv (wikipedia: Kharkiv, wikidata: Q242)>' }
      end

      context 'when unknown data source'
    end

    describe 'identity' do
    end

    describe '#variables' do
    end

    describe '#<variable>' do
    end

    describe '#inspect' do
    end

    describe '#describe' do
    end


    describe '#load' do
      describe 'querying data sources' do
        let(:entity) { described_class.new(wikipedia: 'Kharkiv', wikidata: 'Q242') }

        context 'all available data sources' do
          subject { entity.load }

          its_call {
            is_expected
              .to send_message(Reality::DataSources.wikipedia, :get).with('Kharkiv').returning({})
              .and send_message(Reality::DataSources.wikidata, :get).with('Q242').returning({})
          }
        end

        context 'selected data sources' do
          subject { entity.load(:wikidata) }
        end

        xcontext 'recursive' do
          let(:entity) { described_class.new(wikipedia: 'Kharkiv')
          subject { entity.load(recursive: true) }

          before {
            allow(Reality::DataSources.wikipedia).to receive(:get).with('Kharkiv').returning({wikidata_id: 'Q242'})
          }

          its_call {
            is_expected
              .to send_message(Reality::DataSources.wikidata, :get).with('Q242').returning({})
          }

          context 'selectively recursive' do
            subject { entity.load(recursive: :wikidata) }
          end
        end
      end

      describe 'setting up variables' do
      end
    end

    describe '.load' do
    end
  end
end
