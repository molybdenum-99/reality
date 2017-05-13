require 'reality/data_sources/wikidata'

module Reality
  describe DataSources::Wikidata, :vcr do
    let(:client) { described_class.new }

    subject(:response) { client.find('Q414') }

    it { is_expected.not_to be_empty }
    it { is_expected.to all be_an Observation }

    context 'particular properties' do
      subject { ->(name) { response.detect { |o| o.name == name }.value } }

      its([:_source]) { is_expected.to eq Reality::Link.new(:wikidata, 'Q414') }

      context 'predicates by default' do
        its([:_P1036]) { is_expected.to eq '2--82' }
      end

      context 'predicates with defined aliases' do
        let(:client) { described_class.new(P898: :transcription) }

        its([:transcription]) { is_expected.to eq 'ɑɾgənˈtiːnɑ' }
      end

      context 'links to other sites' do
        subject { response.select { |o| o.name == :_source }.map(&:value) }

        it { is_expected.to include Reality::Link.new(:wikipedia, 'Argentina') }
      end
    end
  end
end
