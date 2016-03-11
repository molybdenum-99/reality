module Reality
  describe Measure do
    describe 'creation' do
      subject{Measure.new(1, 'm')}

      its(:amount){should == 1}
      its(:unit){should == Measure::Unit.new(['m', 1])}
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
      subject{Measure.new(5, 'm')}

      it 'sums compatible' do
        expect(subject + Measure.new(3, 'm')).to eq Measure.new(8, 'm')
        expect(subject - Measure.new(3, 'm')).to eq Measure.new(2, 'm')
      end

      it 'raises on incompatible' do
        expect{subject + Measure.new(3, 's')}.to raise_error(ArgumentError)
      end
    end

    describe 'multiplication' do
      let(:m){Measure.new(8, 'm')}
      let(:s){Measure.new(2, 's')}

      it 'muls' do
        expect(m * 10).to eq Measure.new(80, 'm')
        expect(m * m).to eq Measure.new(64, 'm²')
        expect(m * s).to eq Measure.new(16, 'm·s')
      end

      it 'divs' do
        expect(m / 4).to eq Measure.new(2, 'm')
        expect(m / 16).to eq Measure.new(0.5, 'm')
        expect(m / m).to eq 1
        expect(m / s).to eq Measure.new(4, 'm/s')
      end

      it 'pows' do
        expect(m ** 2).to eq Measure.new(64, 'm²')
      end
    end

    describe 'output' do
      subject{Measure.new(5, 'm')}

      its(:to_s){should == '5m'}
      its(:inspect){should == "#<Reality::Measure(5 m)>"}

      it 'formats very large numbers' do
        expect(Measure.new(5_000_000, 'm').to_s).to eq '5,000,000m'
      end

      it 'formats fractions' do
        expect(Measure.new(0.3, 'm').to_s).to eq '0.3m'
      end
    end

    describe 'to_h' do
      it 'works' do
        expect(Measure.new(0.3, 'm').to_h).to eq(amount: 0.3, unit: 'm')
      end
    end
  end
end
