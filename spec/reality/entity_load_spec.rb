module Reality
  describe Entity, "::load", :vcr do
    context 'any class' do
      context 'when it exists' do
        subject{Entity.load('Paris')}
        it{should be_kind_of(Entity)}
        it{should be_loaded}
      end

      context 'when it not exists' do
        subject{Entity.load('It is not existing definitely')}
        it{should be_nil}
      end
    end

    context 'specified class' do
      context 'when it exists' do
        subject{Entity.load('France', Country)}
        it{should be_kind_of(Entity)}
        it{should be_loaded}
        its(:entity_class){should == Country}
      end

      context 'when it exists but has another class' do
        subject{Entity.load('Paris', Country)}
        it{should be_nil}
      end

      context 'when it not exists' do
        subject{Entity.load('It is not existing definitely', Country)}
        it{should be_nil}
      end
    end
  end
end
