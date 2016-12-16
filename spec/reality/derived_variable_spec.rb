module Reality
  describe DerivedVariable do
    let(:population) { Variable.from_value(:population, 10_000) }
    let(:area) { Variable.from_value(:area, 1000) }

    subject(:density) {
      described_class.new(:density, population, area) { |population, area| population / area }
    }

    context 'derived observartion from components observations' do
      its(:current) { is_expected.to eq 10 }
    end

    it "returns nil if any of formula components' observations is nil"

    context 'merging of base and derived variables' do
    end
  end
end
