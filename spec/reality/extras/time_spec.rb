module Reality
  describe Time do
    before(:all){
      VCR.use_cassette('time-Kiev'){
        @time = Time.new(coords: [50.45, 30.52])
      }
    }

    subject {@time}

    describe '#now' do
      it 'returns current time' do
        expect(subject.now.to_i).to be_within(2).of(::Time.now.to_i)
      end

      it 'returns time with zone' do
        expect(subject.now.utc_offset).to eq(7200)
        expect(subject.now.to_s).to include('+0200')
      end
    end

    describe '#local' do
      it 'returns local time' do
        expect(subject.local(2000, "jan", 1, 20, 15, 1).to_s).to eq('2000-01-01 20:15:01 +0200')
      end
    end

    describe '#parse' do
      it 'gets time from a string' do
        expect(subject.parse('2000-01-01 20:15:01').to_s).to eq('2000-01-01 20:15:01 +0200')
      end
    end

    describe '#zone' do
      it 'returns time zone' do
        expect(subject.zone).to eq('Europe/Kiev')
      end
    end
  end
end
