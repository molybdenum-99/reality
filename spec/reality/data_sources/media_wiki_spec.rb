require 'reality/data_sources/media_wiki'

module Reality
  describe DataSources::MediaWiki do
    let(:client) { VCR.use_cassette('en-wikipedia-metadata') { described_class.new(:wikipedia, 'https://en.wikipedia.org/w/api.php') } }
    let(:page) { VCR.use_cassette('Wikipedia-Argentina') { Infoboxer.wp.get('Argentina') } }
    before {
      expect_any_instance_of(Infoboxer::MediaWiki)
        .to receive(:get).with('Argentina').and_return(page)
    }

    subject(:response) { client.get('Argentina') }

    it { is_expected.not_to be_empty }
    it { is_expected.to all be_a Observation }

    context 'particular properties' do
      subject { ->(name) { response.detect { |o| o.name == name }.value } }

      its([:_source]) { is_expected.to eq Reality::Link.new(:wikipedia, 'Argentina') }
      its([:title]) { is_expected.to eq 'Argentina' }

      context 'with parsers defined' do
        let(:client) {
          VCR.use_cassette('en-wikipedia-metadata') {
            described_class.new(
              :wikipedia, 
              'https://en.wikipedia.org/w/api.php',
              {
                name: :long_name,
                path: ->(p) { p.templates(name: 'Infobox country').fetch('conventional_long_name') },
                coerce: ->(val, *) { val.first.text_ } # TODO: :as_string
              }
            )
          }
        }

        its([:long_name]) { is_expected.to eq 'Argentine Republic' }
      end
    end
  end
end
