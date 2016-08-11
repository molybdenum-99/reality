module Reality
  describe 'Europe', :integrational, entity: 'Europe' do
    its(:area){should == Reality::Measure.new(10_180_000, 'km²')}

    context 'on-demand loading', :vcr do
      subject(:continent){Entity.new('Europe')}

      its(:countries){should be_an List}
      its(:countries){should_not be_empty}
    end
  end
end
