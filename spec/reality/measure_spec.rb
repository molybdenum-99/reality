module Reality
  describe Measure do
    describe 'creation' do
      subject{Measure.new(1, 'm')}

      its(:amount){should == 1}
      its(:unit){should == 'm'}
    end

    describe 'compare' do
      context 'compatible' do
        subject{Measure.new(5, 'm')}
        let(:large){Measure.new(10, 'm')}
        let(:small){Measure.new(2, 'm')}
        let(:equal){Measure.new(5, 'm')}

        it{should eq equal}
        it{should > small}
        it{should < large}

        it 'should process <=>' do
          expect(subject <=> equal).to eq 0
          expect(subject <=> small).to eq 1
          expect(subject <=> large).to eq -1
        end
      end

      context 'incompatible' do
        subject{Measure.new(5, 'm')}

        it 'should fail' do
          expect{subject <=> Measure.new(3, 's')}.to raise_error(ArgumentError)
          expect{subject <=> 5}.to raise_error(ArgumentError)
        end
      end
    end

    describe 'conversion' do
    end

    describe 'sums' do
    end

    describe 'multiplication' do
    end

    describe 'output' do
      subject{Measure.new(5, 'm')}

      its(:to_s){should == '5m'}
      its(:inspect){should == "#<Reality::Measure(5 m)>"}
    end
  end
end
