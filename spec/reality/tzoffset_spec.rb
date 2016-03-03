module Reality
  # Don't forget about: Time.now.utc_offset, Time.zone_info
  describe TZOffset do
    describe :initialize do
      it 'can be created from number of minutes' do
        expect(TZOffset.new(-60).minutes).to eq -60
        expect(TZOffset.new( 60).minutes).to eq 60
      end
    end

    describe :inspect do
      it 'works' do
        expect(TZOffset.new(-60).inspect).to eq '#<Reality::TZOffset(UTC-01:00)>'
        expect(TZOffset.new(+60).inspect).to eq '#<Reality::TZOffset(UTC+01:00)>'
      end
    end

    describe :to_s do
      # TODO: also Time.inspect format: +0200
      it 'works' do
        expect(TZOffset.new(-60).to_s).to eq '-01:00'
        expect(TZOffset.new(+60).to_s).to eq '+01:00'
      end
    end

    describe :now do
      let(:tm){Time.new(2016, 1, 29, 14, 30, 0, '+02:00')}
      before{
        allow(Time).to receive(:now).and_return(tm)
      }
      let(:offset){TZOffset.new(5 * 60 + 45)} # +5:45
      subject{offset.now}
      it{should == Time.new(2016, 1, 29, 18, 15, 0, '+05:45')}
      #its(:utc){should == tm.utc} - strange usec case
    end


    describe :parse do
      it 'can be created from offset str' do
        expect(TZOffset.parse('-01:00').minutes).to eq -60
        expect(TZOffset.parse('+01:00').minutes).to eq 60
        expect(TZOffset.parse('−01:00').minutes).to eq -60
        expect(TZOffset.parse('+05:45').minutes).to eq 60*5 + 45
        expect(TZOffset.parse('UTC').minutes).to eq 0
        expect(TZOffset.parse('UTC+01:00').minutes).to eq 60
        expect(TZOffset.parse('UTC+2').minutes).to eq 120
        expect(TZOffset.parse('+0200').minutes).to eq 120
      end
    end


    describe :local do
      let(:offset){TZOffset.new(5 * 60 + 45)} # +5:45
      subject{offset.local(2016, 1, 29, 18, 15, 0)}
      it{should == Time.new(2016, 1, 29, 18, 15, 0, '+05:45')}
    end

    describe :convert do
      let(:tm){Time.new(2016, 1, 29, 14, 30, 0, '+02:00')}
      let(:offset){TZOffset.new(5 * 60 + 45)} # +5:45
      subject{offset.convert(tm)}
      it{should == Time.new(2016, 1, 29, 18, 15, 0, '+05:45')}
    end
  end
end
