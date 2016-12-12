require 'reality/data_sources/wikipedia'

describe Reality::DataSources::Wikipedia do
  subject(:client) { described_class.new }

  describe '#get_hash', :vcr do
    subject { client.get_hash('Einstein') }

    its_call {
      is_expected
        .to send_message(Infoboxer.wikipedia, :get)
        .with('Einstein', prop: :wbentityusage).calling_original
    }

    it { should be_a Hash }
    its(:keys) { are_expected.to all(be_a(Symbol)).and include(:title) }
    its([:title]) { is_expected.to eq 'Albert Einstein' }
    its([:wikidata_id]) { is_expected.to eq 'Q937' }

    describe 'using rules to fetch data' do
      before do
        described_class.rules.clear

        described_class.infobox 'birth_date', :birthday do |val|
          y, m, d = val.lookup(:Template, name: 'Birth date').fetch('1', '2', '3').map(&:to_s).map(&:to_i)
          Date.new(y, m, d)
        end
      end

      its([:birthday]) { is_expected.to eq Date.new(1879, 3, 14) }
    end
  end

  describe '#list'
  describe '#search'
  # ...and so on
end
