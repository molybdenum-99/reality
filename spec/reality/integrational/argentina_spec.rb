require 'reality/data_sources/media_wiki'
require 'reality/data_sources'
require 'reality/definitions/wikipedia'

module Reality
  describe 'Argentina', :integrational, :vcr do
    let(:entity) { Reality::Entity.find(wikipedia: 'Argentina') }

    subject { entity }

    it { is_expected.to be_an Entity }
    its(:inspect) { is_expected.to eq '#<Reality::Entity wikipedia:Argentina, wikidata:Q414>' }

    its(:sources) { is_expected.to include Link.new(:wikidata, 'Q414') }

    context 'individual values' do
      its([:long_name]) { is_expected.to observe 'Argentine Republic' }
      its([:coord]) { is_expected.to observe Geo::Coord.new(latd: 34, latm: 36, lath: 'S', lngd: 58, lngm: 23, lngh: 'W') }
      its([:area]) { is_expected.to observe Measure['km²'].new(2_780_400) }
      its([:population]) { is_expected.to observe Measure[:person].new(40_117_096) }
      its([:capital]) { is_expected.to observe Link.new(:wikipedia, 'Buenos Aires') }
    end

    context 'sources' do
      its(:sources) { are_expected.to include(Link.new(:wikipedia, 'Q414'), Link.new(:openweathermap, '34.36,58.23')) }
    end

    describe '#describe' do # (sic!)
      its(:describe) { is_expected.to eq %Q{
          |#<Reality::Entity wikipedia:Argentina, wikidata:Q414>
          |      title: Argentina
          |  long_name: Argentine Republic
          |      coord: -34.600000,-58.383333
          |       area: 2,780,400km²
          | population: 40,117,096person
          |    capital: wikipedia:Buenos Aires
        }.unindent
      }
    end

    context 'after loading from wikidata' do
    end

    context 'after loading from openweathermap' do
      subject { entity.load(:openweathermap) }

      its([:temperature]) { is_expected.to observe Measure['°C'].new(26) }

      its(:describe) { is_expected.to include 'temperature: 26°C' }

      context 'with date specified' do
        subject { entity.load(:openweathermap, time: '2017-02-29') }
      end
    end

    context 'on attempt to load from non-existend data source'
    context 'on attempt to load from unknown data source'
  end
end
