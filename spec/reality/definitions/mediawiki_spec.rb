module Reality
  describe Definitions::MediaWiki do
    before do
      described_class.clear
    end

    let(:wikipage) { instance_double('Infoboxer::MediaWiki::Page') }
    subject(:hash){ described_class.parse(wikipage) }

    context 'infobox fields' do
      let(:infobox) { double }

      before do
        allow(wikipage).to receive(:templates)
          .with(name: 'Infobox settlement')
          .and_return([infobox])
      end

      context 'standalone field' do
        before do
          described_class.define do
            infobox_field 'name', :long_name, :string,
              infobox: 'Infobox settlement'
          end
        end

        context 'when there is infobox with this field' do
          before { allow(infobox).to receive(:fetch).with('name').and_return(['London']) }

          its([:long_name]) { is_expected.to eq 'London' }
        end

        context 'when there is infobox, but no field' do
          before { allow(infobox).to receive(:fetch).with('name').and_return([]) }

          it { is_expected.not_to have_key(:long_name) }
        end

        context 'when there is no infobox' do
          let(:infobox) { nil }

          it { is_expected.not_to have_key(:long_name) }
        end
      end

      context 'several alternative infoboxes' do
        before do
          described_class.define do
            infobox_field 'name', :long_name, :string,
              infobox: ['Infobox settlement', 'Infobox city Japan']
          end

          allow(wikipage).to receive(:templates)
            .with(name: 'Infobox city Japan')
            .and_return([infobox])

          allow(infobox).to receive(:fetch).with('name').and_return(['London'])
        end

        its([:long_name]) { is_expected.to eq 'London' }
      end

      context 'several definitions for same infobox type(s)' do
        before do
          described_class.define do
            infobox 'Infobox settlement' do
              infobox_field 'name', :long_name, :string
            end
          end

          allow(infobox).to receive(:fetch).with('name').and_return(['London'])
        end

        its([:long_name]) { is_expected.to eq 'London' }
      end
    end

    context 'free parser block' do
      before do
        b = block
        described_class.define do
          parser :album, :string, &b
        end
      end

      context 'when parsed something' do
        let(:block) { ->(*) { 'foo' } }
        its([:album]) { is_expected.to eq 'foo' }
      end

      context 'when parsed nothing' do
        let(:block) { ->(*) { nil } }

        it { is_expected.to_not have_key(:album) }
      end

    end
  end
end
