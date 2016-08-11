module Reality
  describe Modules do
    describe '.register' do
      let!(:mod) {
        Module.new do
          Modules.register(self){ coord }
        end
      }

      it { expect(described_class.list).to include(array_including(mod)) }
    end

    describe '.include_into' do
      subject(:entity) { double(coord: true, birthday: nil) }

      let!(:mod1) {
        Module.new do
          Modules.register(self) { coord }

          def foo
          end
        end
      }
      let!(:extension2) {
        Module.new do
          Modules.register(self) { birthday }

          def bar
          end
        end
      }

      before { described_class.include_into(entity) }

      it { is_expected.to respond_to(:foo) }
      it { is_expected.to_not respond_to(:bar) }
    end

    describe '#describe' do
    end
  end
end
