describe SalesEngine::Models::Merchant do
  include_context 'model examples'

  describe '#items' do
    let!(:merchant)      { add_instance(:merchant, id: 1) }
    let!(:matching_item) { add_instance(:item, merchant_id: 1) }
    before               { add_instance(:item, merchant_id: 2) }

    it "returns the Item instances whose merchant_id matches the merchant's id" do
      merchant.items.should =~ [matching_item]
    end
  end

  describe '#invoices' do
    let!(:merchant)         { add_instance(:merchant, id: 1) }
    let!(:matching_invoice) { add_instance(:invoice, merchant_id: 1) }
    before                  { add_instance(:invoice, merchant_id: 2) }

    it "returns the Invoice instances whose merchant_id matches the merchant's id" do
      merchant.invoices.should =~ [matching_invoice]
    end
  end
end