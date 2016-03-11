module Reality
  describe Entity do
    context 'basics' do
      subject(:entity){Entity.new('Paris')}
      let(:wikipage){double(title: 'Paris, France', infobox: double(name: 'Infobox countryXX'))}
      let(:wikidata){double(predicates: {})}
      let(:wikipedia){double}
      before{
        allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
      }

      its(:to_s){should == 'Paris'}
      its(:inspect){should == "#<Reality::Entity?(Paris)>"}
    end

    context 'with real entity' do
      let(:entity){
        VCR.use_cassette('Country-Argentina'){
          Entity.load('Argentina')
        }
      }

      context :describe do
        subject{entity._describe}
        it{should include(entity.inspect)}
        it 'renders all properties' do
          entity.values.each do |key, val|
            expect(subject).to include("#{key}: #{val.inspect}")
          end
        end
      end
    end
  end
end
