module Reality
  describe 'Band: Pink Floyd', :integrational, entity: 'Pink Floyd' do
    context 'albums' do
      subject { entity.albums }

      it { is_expected.to be_an Array }
      it { is_expected.to all be_an Entity }
      its(:count) { is_expected.to eq 15 }
      it { expect(subject.map(&:name)).to include('The Dark Side of the Moon') }
    end
  end
end
