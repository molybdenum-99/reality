require 'reality/iruby'
require 'nokogiri'

class Nokogiri::XML::Element
  def idx
    xpath('count(preceding-sibling::*)').to_i
  end
end

module Reality
  describe Measure, '#to_html' do
    let(:data){Measure.new(100, 'kg')}
    let(:html){data.to_html}
    subject(:doc){Nokogiri::HTML(html)}

    its(:text){is_expected.to eq '100kg'}
  end

  describe Geo::Coord, '#to_html' do
    let(:data){Geo::Coord.from_dms([38, 53, 23], [-77, 00, 32])}
    let(:html){data.to_html}
    subject(:doc){Nokogiri::HTML(html)}

    its(:text){is_expected.to eq '38°53′23″N, 77°0′32″W'}
  end

  describe TZOffset, '#to_html' do
    let(:data){TZOffset.parse('UTC+2')}
    let(:html){data.to_html}
    subject(:doc){Nokogiri::HTML(html)}

    its(:text){is_expected.to eq '+02:00'}
  end

  describe Entity do
    context 'when not loaded' do
      let(:country){Reality::Entity.new('Argentina')}

      describe '#to_html' do
        let(:html){country.to_html}
        subject(:doc){Nokogiri::HTML(html)}

        its(:text){is_expected.to eq 'Argentina'}
      end
    end

    context 'when loaded' do
      let(:country){
        VCR.use_cassette('Country-Argentina'){
          Reality::Entity('Argentina')
        }
      }

      describe '#to_html' do
        let(:html){country.to_html}
        subject(:doc){Nokogiri::HTML(html)}

        it 'is a table of all values' do
          expect(doc.search('body > *').count).to eq 1
          tbl = doc.at('body > *')
          expect(tbl.name).to eq 'table'

          labels = tbl.search('th')
          p labels.map(&:text)
          expect(labels.map(&:text)).to contain_exactly *country.values.keys.map(&:to_s)
        end

        def rendered_at(tbl, name)
          i = tbl.search('th').detect{|th| th.text == name}
          i && tbl.search('tr').to_a[i.parent.idx].search('td').last
        end

        it 'renders values appropriately' do
          tbl = doc.at('body > table')
          expect(rendered_at(tbl, 'tld').inner_html).to eq country.tld
          expect(rendered_at(tbl, 'tz_offset').inner_html).to eq country.tz_offset.to_html
          expect(rendered_at(tbl, 'population').inner_html).to eq country.population.to_html
          expect(rendered_at(tbl, 'capital').inner_html).to eq country.capital.to_html
        end
      end

      describe '#compact_html' do
      end
    end
  end

  describe List do
    describe '#to_html' do
    end

    describe '#to_dataframe' do
    end
  end
end
