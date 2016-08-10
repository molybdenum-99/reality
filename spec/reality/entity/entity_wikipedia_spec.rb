module Reality
  describe Entity, 'wikipedia data parsing' do
    subject(:entity){Entity.new('Paris')}
    let(:wikipage){double(title: 'Paris, France')}
    let(:wikidata){double(predicates: {})}
    let(:wikipedia){double}
    let(:infobox){double}

    before do
      Entity::WikipediaData.clear
      Entity::WikipediaData.define{
        infobox 'Infobox country' do
          infobox_field 'area_km2', :area, :measure, unit: 'km²'
        end

        parser :capital, :string do 'London' end
      }
      allow(wikipage).to receive(:templates).with(name: 'Infobox country').and_return([infobox])
      allow(infobox).to receive(:fetch).with('area_km2').
        and_return([double(to_s: '2,780,400')])
    end

    context 'on load' do
      before{
        allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
        allow(wikipedia).to receive(:get).with('Paris').and_return(wikipage)
        allow(Wikidata::Entity).to receive(:one_by_wikititle).
          with('Paris, France').and_return(wikidata)

        entity.load!
      }
      it { is_expected.to have_attributes(area: Measure.new(2_780_400, 'km²'), capital: 'London') }
    end

    context 'for preloaded' do
      subject(:entity){Entity.new('Paris').setup!(wikipage: wikipage, wikidata: wikidata)}
      it { is_expected.to have_attributes(area: Measure.new(2_780_400, 'km²'), capital: 'London') }
    end
  end
end
