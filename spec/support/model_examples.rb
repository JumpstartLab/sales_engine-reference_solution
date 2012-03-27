shared_context 'model examples' do
  describe '.random' do
    before { 5.times { described_class.add_instance } }

    it 'returns a random instance' do
      5.times.map { described_class.random }.uniq.size.should be > 1
    end
  end
end