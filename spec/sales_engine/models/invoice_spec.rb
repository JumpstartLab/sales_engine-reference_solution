describe SalesEngine::Models::Invoice do
  include_context 'model examples'

  describe '.average_items' do
    before do
      4.times do |i|
        add_instance(:invoice, id: i)
        i.next.times do
          add_instance(:invoice_item, invoice_id: i)
        end
      end
    end

    it 'returns the average number of items for each invoice' do
      average_items = SalesEngine::Models::Invoice.average_items
      average_items.should be_a_big_decimal_equating_to(2.5)
    end
  end

  describe '#customer' do
    let!(:invoice) { add_instance(:invoice, customer_id: 1) }
    let!(:matching_customer) { add_instance(:customer, id: 1) }
    before { add_instance(:customer, id: 2) }

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

  describe '#transactions' do
    let!(:invoice) { add_instance(:invoice, id: 1) }
    let!(:matching_transaction) { add_instance(:transaction, invoice_id: 1) }
    before { add_instance(:transaction, invoice_id: 2) }

    it "returns the Transaction instances whose invoice_id matches the invoice's id" do
      invoice.transactions.should =~ [matching_transaction]
    end
  end
end