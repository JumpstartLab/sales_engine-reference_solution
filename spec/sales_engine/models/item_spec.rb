describe SalesEngine::Models::Item do
  include_context 'model examples'

  describe '#invoice_items' do
    let!(:item) { add_instance(:item, id: 1) }
    let!(:matching_invoice_item) { add_instance(:invoice_item, item_id: 1) }
    before { add_instance(:invoice_item, item_id: 2) }

    it "returns the InvoiceItem instances whose item_id matches the item's id" do
      item.invoice_items.should =~ [matching_invoice_item]
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
      item.invoices.should =~ [matching_invoice]
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
    let(:best_day) { '2012-02-26 20:56:50 UTC' }

    before do
      3.times do |i|
        add_instance(:invoice, id: i, created_at: best_day)
        add_instance(:invoice_item, invoice_id: i, item_id: 1)
      end

      [3, 4].each do |i|
        add_instance(:invoice, id: i, created_at: '2012-02-25 20:56:50 UTC')
        add_instance(:invoice_item, invoice_id: i, item_id: 1)
      end

      add_instance(:invoice, id: 5, created_at: '2012-02-27 20:56:50 UTC')
      add_instance(:invoice_item, invoice_id: 5, item_id: 1)
    end

    it 'returns the date with the most invoices associated with the item' do
      item.best_day.should eq Date.parse(best_day)
    end
  end
end