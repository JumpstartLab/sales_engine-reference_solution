describe SalesEngine::Models::Item do
  include_context 'model examples'

  describe '.most_revenue' do
    {one: 30, two: 20, three: 10}.each do |k, v|
      let("item_#{k}") do
        double("item_#{k}", invoices: [double(revenue: v)])
      end
    end

    before do
      SalesEngine::Models::Item.should_receive(:instances) do
        [item_three, item_two, item_one]
      end
    end

    context 'given a limit of 2' do
      it 'returns the top 2 Item instances in descending order by revenue' do
        SalesEngine::Models::Item.most_revenue(2).should eq [item_one, item_two]
      end
    end
  end

  describe '.most_items' do
    {one: 30, two: 20, three: 10}.each do |k, v|
      let("item_#{k}") do
        double("item_#{k}", invoice_items: 2.times.map { double(quantity: v) })
      end
    end

    before do
      SalesEngine::Models::Item.should_receive(:instances) do
        [item_three, item_two, item_one]
      end
    end

    context 'given a limit of 2' do
      it 'returns the top 2 Item instances in descending order by total number sold' do
        SalesEngine::Models::Item.most_items(2).should eq [item_one, item_two]
      end
    end
  end

  describe '#invoice_items' do
    let!(:item) { add_instance(:item, id: 1) }
    let!(:matching_invoice_item) { add_instance(:invoice_item, item_id: 1) }
    before { add_instance(:invoice_item, item_id: 2) }

    it "returns the InvoiceItem instances whose item_id matches the item's id" do
      item.invoice_items.should eq [matching_invoice_item]
    end
  end

  describe '#invoices' do
    let!(:item) { add_instance(:item, id: 1) }
    let!(:matching_invoice) { add_instance(:invoice, id: 1) }

    before do
      add_instance(:invoice_item, invoice_id: 1, item_id: 1)

      add_instance(:item, id: 2)
      add_instance(:invoice, id: 2)
      add_instance(:invoice_item, invoice_id: 2, item_id: 2)
    end

    it "returns the Invoice instances whose id matches the invoice_id of the item's invoice_items" do
      item.invoices.should eq [matching_invoice]
    end
  end

  describe '#merchant' do
    let!(:item) { add_instance(:item, id: 1, merchant_id: 1) }
    let!(:matching_merchant) { add_instance(:merchant, id: 1) }
    before { add_instance(:merchant, id: 2) }

    it "returns a Merchant instance whose id matches the item's merchant_id" do
      item.merchant.should eq matching_merchant
    end
  end

  describe '#best_day' do
    let!(:item) { add_instance(:item, id: 1) }
    let(:best_day) { the_date }

    before do
      3.times do |i|
        add_instance(:invoice, id: i, created_at: best_day.to_s)
        add_instance(:invoice_item, invoice_id: i, item_id: 1)
      end

      [3, 4].each do |i|
        add_instance(:invoice, id: i, created_at: best_day.prev_day.to_s)
        add_instance(:invoice_item, invoice_id: i, item_id: 1)
      end

      add_instance(:invoice, id: 5, created_at: best_day.next_day.to_s)
      add_instance(:invoice_item, invoice_id: 5, item_id: 1)
    end

    it 'returns the date with the most invoices associated with the item' do
      item.best_day.should eq best_day
    end
  end
end