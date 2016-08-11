module Reality
  describe 'Continent: South America', :integrational, entity: 'South America' do
    its(:area){should == Reality::Measure.new(17_840_000, 'km²')}
  end
end
