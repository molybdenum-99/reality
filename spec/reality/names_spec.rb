module Reality
  describe Names do
    let(:entity){double}
    
    context 'on itself' do
      it 'returns named entity' do
        expect(Reality).to receive(:Entity).with('Argentina').and_return(entity)
        expect(Names::Argentina).to eq entity
      end

      it 'converts names' do
        expect(Reality).to receive(:Entity).with('Buenos Aires').and_return(entity)
        expect(Names::Buenos_Aires).to eq entity

        expect(Reality).to receive(:Entity).with('Buenos Aires').and_return(entity)
        expect(Names::BuenosAires).to eq entity
      end

      it 'raises on not found entity' do
        expect(Reality).to receive(:Entity).with('Argentina').and_return(nil)
        expect{Names::Argentina}.to raise_error(NameError)
      end
    end

    context 'being included' do
      let(:mod){Module.new}
      before{
        mod.include Names
      }
      it 'returns named entity' do
        expect(Reality).to receive(:Entity).with('Argentina').and_return(entity)
        expect(mod::Argentina).to eq entity
      end
    end
  end
end
