describe SalesEngine::Models::InvoiceItem do
  include_context 'model examples'

  describe '#invoice' do
    let!(:invoice_item) { add_instance(:invoice_item, invoice_id: 1) }
    let!(:matching_invoice) { add_instance(:invoice, id: 1) }
    before { add_instance(:invoice, id: 2) }

    it "returns an Invoice instance whose id matches the invoice_item's invoice_id" do
      invoice_item.invoice.should eq matching_invoice
    end
  end

  describe '#item' do
    let!(:invoice_item) { add_instance(:invoice_item, item_id: 1) }
    let!(:matching_item) { add_instance(:item, id: 1) }
    before { add_instance(:item, id: 2) }

    it "returns an Item instance whose id matches the invoice_item's item_id" do
      invoice_item.item.should eq matching_item
    end
  end

  describe '#total_amount' do
    let(:invoice_item) do
      add_instance(:invoice_item, unit_price: 10, quantity: 3)
    end

    it 'returns the unit_price multiplied by the quantity' do
      invoice_item.total_amount.should eq 30
    end
  end
end