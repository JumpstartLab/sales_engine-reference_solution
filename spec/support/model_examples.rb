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

    context 'given a range' do
      context "with dates that span the instance's created_at date" do
        it 'returns true' do
          instance.should be_created_on(date.prev_day..date.next_day)
        end
      end

      context "with dates that do not span the instance's created_at date" do
        it 'returns false' do
          range_of_dates = date.prev_day.prev_day..date.prev_day
          instance.should_not be_created_on(range_of_dates)
        end
      end
    end

    context 'given a single date' do
      context "that is equivalent to the instance's created_at date" do
        it 'returns true' do
          instance.should be_created_on(date)
        end
      end

      context "that is not equivalent to the instance's created_at date" do
        it 'returns false' do
          instance.should_not be_created_on(date.prev_day)
        end
      end
    end
  end

  describe '#created_at_date' do
    let(:date) { the_date }
    let(:instance) { described_class.add_instance(created_at: date.to_s) }

    it "returns the instance's created_at as a Date instance" do
      instance.created_at_date.should eq date
    end
  end
end