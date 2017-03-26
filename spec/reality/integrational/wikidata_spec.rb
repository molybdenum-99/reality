require 'reality/data_sources/wikidata'
require 'reality/data_sources'
require 'reality/definitions/wikidata'

module Reality
  describe 'Entity from wikidata', :integrational do
    describe '.wikidata', :vcr do
      subject { Reality.data_sources[:wikidata] }

      it { is_expected.to be_a Reality::DataSources::Wikidata }
    end

    describe 'Argentina', :vcr do
      subject(:entity) { Reality::Entity.find(wikidata: 'Q414') }

      it { is_expected.to be_an Entity }
      its(:inspect) { is_expected.to eq '#<Reality::Entity wikidata:Q414>' }

      # TODO: wikipedia source

      context 'individual values' do
        subject { ->(n) { entity[n].first&.value } }

        # TODO: autoparsed values
        # TODO: forced-type values
      end
    end
  end
end
