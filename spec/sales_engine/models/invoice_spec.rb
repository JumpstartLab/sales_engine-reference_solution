describe SalesEngine::Models::Invoice do
  include_context 'model examples'

  describe '#customer' do
    let!(:invoice) { add_instance(:invoice, customer_id: 1) }
    let!(:matching_customer) { add_instance(:customer, id: 1) }

    it "returns a Customer instance whose id matches the invoice's customer_id" do
      invoice.customer.should eq matching_customer
    end
  end
end