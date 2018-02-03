require 'reality/describers/wikidata/units'

RSpec.describe Reality::Describers::Wikidata::Units do
  describe '.parse' do
    subject { described_class.method(:parse) }

    context 'synonyms' do
      its_call('metre') { is_expected.to ret 'm' }
      its_call('meter') { is_expected.to ret 'm' }
    end

    context 'per' do
      its_call('m per s') { is_expected.to ret 'm/s' }
    end
  end
end
