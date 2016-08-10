module Reality
  describe Entity::Extension do
    describe '#condition' do
      let!(:extension) {
        Module.new do
          extend Entity::Extension
          condition { |e| e.coord }
        end
      }

      it { expect(described_class.list).to include(array_including(extension)) }
    end

    describe '.apply_to' do
      subject(:entity) { double(coord: true, birthday: nil) }

      let!(:extension1) {
        Module.new do
          extend Entity::Extension
          condition { |e| e.coord }

          def foo
          end
        end
      }
      let!(:extension2) {
        Module.new do
          extend Entity::Extension
          condition { |e| e.birthday }

          def bar
          end
        end
      }

      before { described_class.apply_to(entity) }

      it { is_expected.to respond_to(:foo) }
      it { is_expected.to_not respond_to(:bar) }
    end

    describe '#describe' do
    end
  end
end
