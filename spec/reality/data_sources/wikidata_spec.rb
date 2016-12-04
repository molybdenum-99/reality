require 'reality/data_sources/wikidata'

describe Reality::DataSources::Wikidata do
  subject(:client) { described_class.new }

  describe '#get', :vcr do
    subject { client.get('Q42') }

    its_call {
      is_expected
        .to send_message(Reality::Wikidata::Entity, :one_by_id)
        .with('Q42').calling_original
    }

    it { should be_a Hash }
    its(:keys) { is_expected.to all(be_a(Symbol)).and include(:id) }

    describe 'using rules to fetch data' do
      before do
        described_class.rules.clear

        described_class.predicate 'P569', :birthday, Date
      end

      its([:birthday]) { is_expected.to eq Date.new(1952, 03, 11) }
    end
  end

  describe '#first' do
  end
end
