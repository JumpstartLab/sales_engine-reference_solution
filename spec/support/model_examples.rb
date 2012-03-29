shared_context 'model examples' do
  describe '.random' do
    before { 5.times { described_class.add_instance } }

    it 'returns a random instance' do
      5.times.map { described_class.random }.uniq.size.should be > 1
    end
  end

  describe '#created_on?' do
    let(:date) { the_date }
    let(:instance) { described_class.add_instance(created_at: date.to_s) }

    context "given a date that is equivalent to the instance's created_at date" do
      it 'returns true' do
        instance.should be_created_on(date)
      end
    end

    context "given a date that is not equivalent to the instance's created_at date" do
      it 'returns false' do
        instance.should_not be_created_on(date.prev_day)
      end
    end
  end
end