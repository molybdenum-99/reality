module Reality
  describe Entity do
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

    describe '#variables' do
    end

    describe '#<variable>' do
    end

    describe '#inspect' do
    end

    describe '#describe' do
    end

    describe '.load' do
    end
  end
end
