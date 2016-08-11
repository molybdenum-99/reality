module Reality
  describe 'Character: Chewbacca', :integrational, entity: 'Chewbacca' do
    its(:'species.name'){should == 'Wookiee'}
  end
end
