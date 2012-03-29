describe SalesEngine::Models::Customer do
  include_context 'model examples'

  describe '#invoices' do
    let!(:customer) { add_instance(:customer, id: 1) }
    let!(:matching_invoice) { add_instance(:invoice, customer_id: 1) }
    before { add_instance(:invoice, customer_id: 2) }

    it "returns the Invoice instances whose customer_id matches the customer's id" do
      customer.invoices.should eq [matching_invoice]
    end
  end

  describe '#transactions' do
    let!(:customer) { add_instance(:customer, id: 1) }
    let!(:matching_transaction) { add_transaction(invoice_id: 1) }

    before do
      add_instance(:invoice, id: 1, customer_id: 1)
      add_transaction(invoice_id: 2)
    end

    it "returns the Transaction instances associated with the customer's invoices" do
      customer.transactions.should eq [matching_transaction]
    end
  end
end