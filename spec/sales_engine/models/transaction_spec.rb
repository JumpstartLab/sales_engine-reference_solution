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

  describe '#successful?' do
    context %|with the transaction's result as "success"| do
      let(:transaction) { add_instance(:transaction, result: 'success') }

      it 'returns true' do
        transaction.should be_successful
      end
    end

    context %|with the transaction's result as "fail"| do
      let(:transaction) { add_instance(:transaction, result: 'fail') }

      it 'returns false' do
        transaction.should_not be_successful
      end
    end
  end
end