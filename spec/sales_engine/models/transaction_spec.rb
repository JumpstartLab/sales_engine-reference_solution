describe SalesEngine::Models::Transaction do
  include_context 'model examples'

  describe '#invoice' do
    let!(:transaction) { add_instance(:transaction, invoice_id: 1) }
    let!(:matching_invoice) { add_instance(:invoice, id: 1) }
    before { add_instance(:invoice, id: 2) }

    it "returns an Invoice instance whose id matches the transactions's invoice_id" do
      transaction.invoice.should eq matching_invoice
    end
  end
end