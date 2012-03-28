describe SalesEngine::Models::Customer do
  include_context 'model examples'

  describe '#invoices' do
    let!(:customer) { add_instance(:customer, id: 1) }
    let!(:matching_invoice) { add_instance(:invoice, customer_id: 1) }
    before { add_instance(:invoice, customer_id: 2) }

    it "returns the Invoice instances whose customer_id matches the customer's id" do
      customer.invoices.should =~ [matching_invoice]
    end
  end
end