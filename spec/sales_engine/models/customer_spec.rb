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

  describe '#favorite_merchant' do
    let!(:customer) { add_instance(:customer, id: 1) }
    let!(:favorite_merchant) { add_instance(:merchant, id: 1) }

    before do
      3.times { add_instance(:invoice, customer_id: 1, merchant_id: 1)  }

      add_instance(:merchant, id: 2)
      2.times { add_instance(:invoice, customer_id: 1, merchant_id: 2) }
    end

    it 'returns the Merchant instance where the customer has the most invoices' do
      customer.favorite_merchant.should eq favorite_merchant
    end
  end

  describe '#days_since_activity' do
    let!(:customer) { add_instance(:customer) }

    before do
      customer.should_receive(:transactions) {[
        double(created_at: DateTime.now - 6),
        double(created_at: DateTime.now - 5)
      ]}
    end

    it "returns the number of days since the customer's last transaction" do
      customer.days_since_activity.should eq 5
    end
  end

  describe '#pending_invoices' do
    let!(:customer) { add_instance(:customer) }
    let!(:matching_invoice) { double(paid?: false) }

    before do
      customer.should_receive(:invoices) {[
        matching_invoice, double(paid?: true)
      ]}
    end

    it "returns Invoice instances for the customer's invoices that are unpaid" do
      customer.pending_invoices.should eq [matching_invoice]
    end
  end
end