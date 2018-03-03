RSpec.describe Reality::Describers::Wikipedia, :vcr do
  let(:describer) { described_class.new }
  before { VCR.use_cassette('wikipedia-meta') { describer.__send__(:internal) } }

  describe '#query' do
    let(:query) { describer.query(**params) }

    shared_examples 'maps request' do |request_params, query_pattern|
      context "with #{request_params}" do
        let(:params) { request_params }
        subject! { query.load }
        specify {
          expect(WebMock).to have_requested(:get, /en\.wikipedia\.org/)
            .with(query: hash_including(query_pattern))
        }
        it { is_expected.not_to be_empty }
      end
    end

    it_behaves_like 'maps request',
      {category: 'Star Wars'},
      {list: 'categorymembers', cmtitle: 'Category:Star Wars'}

    it_behaves_like 'maps request',
      {search: 'Chewbacca'},
      {list: 'search', srsearch: 'Chewbacca'}

    it_behaves_like 'maps request',
      {around: Geo::Coord.new(0, 0), radius: 1000},
      {list: 'geosearch', gscoord: '0.000000|0.000000', gsradius: '1000'}

    it_behaves_like 'maps request',
      {around: '50.004444, 36.231389', radius: 1000},
      {list: 'geosearch', gscoord: '50.004444|36.231389', gsradius: '1000'}
  end

end