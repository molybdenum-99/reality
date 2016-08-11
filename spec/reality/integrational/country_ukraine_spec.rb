module Reality
  describe 'Country: Ukraine', :integrational, entity: 'Ukraine' do
    describe 'measures' do
      its(:area){should == Reality::Measure(603_500, 'km²')}
    end
  end
end
