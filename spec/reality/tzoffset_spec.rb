module Reality
  # Don't forget about: Time.now.utc_offset, Time.zone_info
  #describe TZOffset do
    #describe :initialize do
      #it 'can be created from number of minutes' do
        #expect(TZOffset.new(-60).value).to eq -60
        #expect(TZOffset.new(60).value).to eq 60
      #end
      
      ## TODO: also Time.inspect format: +0200
      ## and also UTC+2/GMT+2 formats
      #it 'can be created from offset str' do
        #expect(TZOffset.new('-01:00').value).to eq -60
        #expect(TZOffset.new('+01:00').value).to eq 60
        #expect(TZOffset.new('−01:00').value).to eq -60
        #expect(TZOffset.new('+05:45').value).to eq 60*5 + 45

        #expect(TZOffset.new('UTC').value).to eq 0
        #expect(TZOffset.new('UTC+01:00').value).to eq 60
      #end
    #end

    #describe :parse do
    #end

    #describe :inspect do
      ## TODO: global reality Unicode turn-off
      #it 'works' do
        #expect(TZOffset.new('-01:00').inspect).to eq '#<Reality::TZOffset(UTC−01:00)>'
        #expect(TZOffset.new('+01:00').inspect).to eq '#<Reality::TZOffset(UTC+01:00)>'
      #end
    #end

    #describe :to_s do
      ## TODO: also Time.inspect format: +0200
      #it 'works' do
        #expect(TZOffset.new('-01:00').to_s).to eq '-01:00'
        #expect(TZOffset.new('+01:00').to_s).to eq '+01:00'
      #end
    #end

    #describe :now do
      #before{
        #allow(Time).to receive(:now).and_return(tm)
      #}
      #let(:offset){TZOffset.new('+5:45')}
      #subject{offset.now}
      #it{should == }
    #end

    #describe :localtime do
    #end

    #describe :convert do
    #end
  #end
end
