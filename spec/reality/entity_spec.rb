module Reality
  describe Entity do
    let(:observations) {
      [
        Observation.new(:_source, Link.new(:wikipedia, 'Johnny Depp')),
        Observation.new(:name, 'John'),
        Observation.new(:age, 21),
        Observation.new(:father, Link.new(:wikipedia, 'Jeff Bridges'))
      ]
    }

    subject(:entity) { Entity.new(observations) }
    
    describe '#initialize' do
      its(:observations) { are_expected.to eq observations }
    end

    describe '#[]' do
      its([:age]) { is_expected.to eq [Observation.new(:age, 21)] }
    end

    context 'sources' do
      # loaded source
      # not loaded source
    end

    describe '#inspect' do
      its(:inspect) { is_expected.to eq '#<Reality::Entity wikipedia:Johnny Depp>' }
    end

    describe '#describe' do # (sic)
      its(:describe) {
        is_expected.to eq %Q{
          |#<Reality::Entity wikipedia:Johnny Depp>
          |   name: John
          |    age: 21
          | father: wikipedia:Jeff Bridges
        }.unindent
      }
    end
  end
end
 
