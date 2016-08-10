module Kernel
  def eigenclass
    class << self
      self
    end
  end
end

module Reality
  describe Entity, 'applying extensions' do
    subject(:entity){Entity.new('Paris')}

    let!(:extension1) {
      Module.new do
        extend Entity::Extension
        condition { |e| true }

        def foo
          'foo'
        end
      end
    }
    let!(:extension2) {
      Module.new do
        extend Entity::Extension
        condition { |e| false }

        def bar
          'bar'
        end
      end
    }

    context 'before entity loaded' do
      its(:'eigenclass.included_modules') { is_expected.not_to include extension1 }
      its(:'eigenclass.included_modules') { is_expected.not_to include extension2 }
    end

    context 'when entity loaded' do
      let(:wikipage){double(title: 'Paris, France', templates: [])}
      let(:wikidata){double(predicates: {})}
      let(:wikipedia){double}
      before{
        allow(Infoboxer).to receive(:wikipedia).and_return(wikipedia)
        expect(wikipedia).to receive(:get).
          with('Paris').and_return(wikipage)
        expect(Wikidata::Entity).to receive(:one_by_wikititle).
          with('Paris, France').and_return(wikidata)
        entity.load!
      }
      its(:'eigenclass.included_modules') { is_expected.to include extension1 }
      its(:'eigenclass.included_modules') { is_expected.not_to include extension2 }

    end
  end
end
