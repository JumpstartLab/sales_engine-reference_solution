describe SalesEngine::Models::Invoice do
  include_context 'model examples'

  describe '.average_items' do
    pending 'returns the average number of items for each invoice' do
    end
  end

  describe '#customer' do
    let!(:invoice) { add_instance(:invoice, customer_id: 1) }
    let!(:matching_customer) { add_instance(:customer, id: 1) }

    it "returns a Customer instance whose id matches the invoice's customer_id" do
      invoice.customer.should eq matching_customer
    end
  end

  describe '#invoice_items' do
    let!(:invoice) { add_instance(:invoice, id: 1) }
    let!(:matching_invoice_item) { add_instance(:invoice_item, invoice_id: 1) }
    before { add_instance(:invoice_item, invoice_id: 2) }

    it "returns the InvoiceItem instances whose invoice_id matches the invoice's id" do
      invoice.invoice_items.should =~ [matching_invoice_item]
    end
  end

  describe '#items' do
    let!(:invoice) { add_instance(:invoice, id: 1) }
    let!(:matching_item) { add_instance(:item, id: 1) }

    before do
      add_instance(:invoice_item, item_id: 1, invoice_id: 1)
      add_instance(:item, id: 2)
    end

    it "returns the Item instances whose id matches the item_id of the invoice's invoice_items" do
      invoice.items.should =~ [matching_item]
    end
  end
end