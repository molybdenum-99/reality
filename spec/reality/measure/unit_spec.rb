module Reality
  #descirbe Atom do
  #end

  #describe Power do
    #describe :to_s do
      #it 'works' do
        #expect(Power.new('m', 1).to_s).to eq 'm'
        #expect(Power.new('m', 2).to_s).to eq 'm²'
        #expect(Power.new('m', -1).to_s).to eq '1/m'
      #end
    #end
  #end

  describe Measure::Unit do
    describe :initialize do
      it 'creates' do
        u = Measure::Unit.new(['m', 1], ['s', 2], ['N', -1])
        expect(u.components).to eq [['m', 1], ['s', 2], ['N', -1]]
      end

      it 'simplifies' do
        u = Measure::Unit.new(['m', 1], ['s', 2], ['m', 1])
        expect(u.components).to eq [['m', 2], ['s', 2]]

        u = Measure::Unit.new(['m', 1], ['s', 2], ['m', -1])
        expect(u.components).to eq [['s', 2]]
      end

      it 'fails on unexpected input'
    end

    describe :== do
      it 'works' do
        expect(Measure::Unit.new(['m', 1])).to eq Measure::Unit.new(['m', 1])
        expect(Measure::Unit.new(['m', 1])).not_to eq Measure::Unit.new(['m', 2])
        expect(Measure::Unit.new(['m', 1])).not_to eq Measure::Unit.new(['m', 1], ['s', -1])
      end
    end

    describe :to_s do
      it 'renders simple' do
        expect(Measure::Unit.new(['m', 1]).to_s).to eq 'm'
        expect(Measure::Unit.new(['m', 2]).to_s).to eq 'm²'
        expect(Measure::Unit.new(['m', 20]).to_s).to eq 'm^20'
      end

      it 'renders multiplication' do
        expect(Measure::Unit.new(['m', 1], ['s', 2]).to_s).to eq 'm·s²'
      end

      it 'renders division' do
        expect(Measure::Unit.new(['m', 1], ['s', -2]).to_s).to eq 'm/s²'
        expect(Measure::Unit.new(['m', -1]).to_s).to eq '1/m'
      end

      it 'renders really complex things' do
        expect(Measure::Unit.new(['m', 1], ['g', 2], ['s', -2]).to_s).to eq 'm·g²/s²'
      end

      it 'has no-Unicode mode' do
        Measure::Unit.unicode = false
        expect(Measure::Unit.new(['m', 1], ['g', 2], ['s', -2]).to_s).to eq 'm*g^2/s^2'
        Measure::Unit.unicode = true
      end
    end

    describe :-@ do
      it 'works' do
        u = Measure::Unit.new(['m', 1])
        expect(-u).to eq Measure::Unit.new(['m', -1])

        u2 = Measure::Unit.new(['m', 1], ['s', 2], ['g', -1])
        expect(-u2).to eq Measure::Unit.new(['m', -1], ['s', -2], ['g', 1])
      end
    end

    describe :* do
      it 'constructs new units' do
        m = Measure::Unit.new(['m', 1])
        s = Measure::Unit.new(['s', 1])
        expect(m*s).to eq Measure::Unit.new(['m', 1], ['s', 1])
      end

      it 'simplifies' do
        m = Measure::Unit.new(['m', 1])
        s = Measure::Unit.new(['s', 1])
        expect(m * m).to eq Measure::Unit.new(['m', 2])
        expect(m * s * -m).to eq Measure::Unit.new(['s', 1])
      end
    end

    describe :/ do
      it 'is just multiplication!' do
        m = Measure::Unit.new(['m', 1])
        s = Measure::Unit.new(['s', 1])
        expect(m / s).to eq Measure::Unit.new(['m', 1], ['s', -1])
        expect(m / m).to be_scalar
      end
    end

    describe :parse do
      it 'parses simple' do
        expect(Measure::Unit.parse('m')).to eq Measure::Unit.new(['m', 1])
        expect(Measure::Unit.parse('person')).to eq Measure::Unit.new(['person', 1])
      end

      it 'parses powers' do
        expect(Measure::Unit.parse('m²')).to eq Measure::Unit.new(['m', 2])
        expect(Measure::Unit.parse('m^20')).to eq Measure::Unit.new(['m', 20])
      end

      it 'parses multiplications' do
        expect(Measure::Unit.parse('m²*kg')).to eq Measure::Unit.new(['m', 2], ['kg', 1])
        expect(Measure::Unit.parse('m²·kg')).to eq Measure::Unit.new(['m', 2], ['kg', 1])
      end

      it 'parses divisions' do
        expect(Measure::Unit.parse('m²/kg')).to eq Measure::Unit.new(['m', 2], ['kg', -1])
      end

      it 'parses everythin!' do
        expect(Measure::Unit.parse('m²*s/kg*N³')).to eq Measure::Unit.new(['m', 2], ['s', 1], ['kg', -1], ['N', -3])
      end
    end
  end
end
