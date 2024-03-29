describe SalesEngine::Models::Invoice do
  include_context 'model examples'

  describe '.create' do
    let(:attributes) { {} }

    def create
      SalesEngine::Models::Invoice.create(attributes)
    end

    def invoice_instance
      SalesEngine::Models::Invoice.instances.first
    end

    it 'creates an Invoice instance' do
      expect { create }.to change {
        SalesEngine::Models::Invoice.instances.size
      }.from(0).to(1)
    end

    context 'with a :customer' do
      let(:customer) { add_instance(:customer, id: 1) }

      it 'associates the customer with the created Invoice instance' do
        attributes.merge!(customer: customer)
        create
        invoice_instance.customer.should eq customer
      end
    end

    context 'with a :merchant' do
      let(:merchant) { add_instance(:merchant, id: 1) }

      it 'associates the merchant with the created Invoice instance' do
        attributes.merge!(merchant: merchant)
        create
        invoice_instance.merchant.should eq merchant
      end
    end

    context 'with :items' do
      let(:item_1) { add_instance(:item, id: 1, unit_price: 5) }
      let(:item_2) { add_instance(:item, id: 2, unit_price: 6) }

      before { attributes.merge!(items: [item_1, item_2, item_2]) }

      it 'creates an InvoiceItem instance for each unique item' do
        expect { create }.to change {
          SalesEngine::Models::InvoiceItem.instances.size
        }.from(0).to(2)

        invoice_items = SalesEngine::Models::InvoiceItem.instances

        invoice_items.first.tap do |invoice_item|
          invoice_item.quantity.should eq 1
          invoice_item.unit_price.should eq 5
        end

        invoice_items.last.tap do |invoice_item|
          invoice_item.quantity.should eq 2
          invoice_item.unit_price.should eq 6
        end
      end

      it 'associates each item with the created Invoice instance' do
        create
        invoice_instance.items.should =~ [item_1, item_2]
      end
    end
  end

  describe '.pending' do
    let(:unpaid_invoice) { add_instance(:invoice) }

    before do
      unpaid_invoice.should_receive(:paid?).and_return(false)

      add_instance(:invoice).tap do |invoice|
        invoice.should_receive(:paid?).and_return(true)
      end
    end

    it 'returns all of the Invoice instances that are unpaid' do
      SalesEngine::Models::Invoice.pending.should eq [unpaid_invoice]
    end
  end

  describe '.average_items' do
    let(:date) { the_date }

    before do
      4.times do |i|
        add_instance(:invoice, created_at: date.prev_day.to_s).tap do |invoice|
          invoice.stub(:total_items_count).and_return(i.next)
        end
      end
    end

    context 'given no date' do
      it 'returns the average number of items for each Invoice instance' do
        average_items = SalesEngine::Models::Invoice.average_items
        average_items.should be_a_big_decimal_equating_to(2.5)
      end
    end

    context 'given a date' do
      before do
        4.times do |i|
          add_instance(:invoice, created_at: date.to_s).tap do |invoice|
            invoice.should_receive(:total_items_count).and_return(i.next)
          end
        end
      end

      it 'returns the average number of items for each Invoice instance created on the date' do
        average_items = SalesEngine::Models::Invoice.average_items(date)
        average_items.should be_a_big_decimal_equating_to(2.5)
      end
    end
  end

  describe '.average_revenue' do
    let(:date) { the_date }

    before do
      4.times do |i|
        add_instance(:invoice, created_at: date.prev_day.to_s).tap do |invoice|
          invoice.stub(:revenue).and_return(i.next)
        end
      end
    end

    context 'given no date' do
      it 'returns the average revenue for all of the Invoice instances' do
        average_revenue = SalesEngine::Models::Invoice.average_revenue
        average_revenue.should be_a_big_decimal_equating_to(2.5)
      end
    end

    context 'given a date' do
      before do
        4.times do |i|
          add_instance(:invoice, created_at: date.to_s).tap do |invoice|
            invoice.stub(:revenue).and_return(i.next.next)
          end
        end
      end

      it 'returns the average revenue for all of the Invoice instances created on the date' do
        average_revenue = SalesEngine::Models::Invoice.average_revenue(date)
        average_revenue.should be_a_big_decimal_equating_to(3.5)
      end
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

  describe '#merchant' do
    let!(:invoice) { add_instance(:invoice, merchant_id: 1) }
    let!(:matching_merchant) { add_instance(:merchant, id: 1) }
    before { add_instance(:merchant, id: 2) }

    it "returns a Merchant instance whose id matches the invoice's merchant_id" do
      invoice.merchant.should eq matching_merchant
    end
  end

  describe '#invoice_items' do
    let!(:invoice) { add_instance(:invoice, id: 1) }
    let!(:matching_invoice_item) { add_instance(:invoice_item, invoice_id: 1) }
    before { add_instance(:invoice_item, invoice_id: 2) }

    it "returns the InvoiceItem instances whose invoice_id matches the invoice's id" do
      invoice.invoice_items.should eq [matching_invoice_item]
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
      invoice.items.should eq [matching_item]
    end
  end

  describe '#transactions' do
    let!(:invoice) { add_instance(:invoice, id: 1) }
    let!(:matching_transaction) { add_instance(:transaction, invoice_id: 1) }
    before { add_instance(:transaction, invoice_id: 2) }

    it "returns the Transaction instances whose invoice_id matches the invoice's id" do
      invoice.transactions.should eq [matching_transaction]
    end
  end

  describe '#total_amount' do
    let(:invoice) { add_instance(:invoice, id: 1) }

    before do
      invoice.should_receive(:invoice_items) do
        2.times.map { double(total_amount: 25) }
      end
    end

    it "returns the sum of the invoice's invoice_items total amount" do
      invoice.total_amount.should eq 50
    end
  end

  describe '#total_items_count' do
    let!(:invoice) { add_instance(:invoice, id: 1) }

    before do
      add_instance(:invoice_item, invoice_id: 1, quantity: 2)
      add_instance(:invoice_item, invoice_id: 1, quantity: 3)
    end

    it "returns the sum of the invoice's invoice_items quantity" do
      invoice.total_items_count.should eq 5
    end
  end

  describe '#paid?' do
    let!(:invoice) { add_instance(:invoice, id: 1) }

    context 'with successful transactions' do
      before { add_transaction(invoice_id: 1) }

      it 'returns true' do
        invoice.should be_paid
      end
    end

    context 'with no successful transactions' do
      it 'returns false' do
        invoice.should_not be_paid
      end
    end
  end

  describe '#revenue' do
    let!(:invoice) { add_instance(:invoice) }

    context "with the invoice being paid" do
      before do
        invoice.should_receive(:paid?).and_return(true)
        invoice.should_receive(:total_amount).and_return(5)
      end

      it "returns the invoice's total_amount" do
        invoice.revenue.should eq 5
      end
    end

    context "with the invoice not being paid" do
      before { invoice.should_receive(:paid?).and_return(false) }

      it 'returns 0' do
        invoice.revenue.should eq 0
      end
    end
  end

  describe '#charge' do
    let!(:invoice) { add_instance(:invoice, id: 1) }

    let(:attributes) {{
      credit_card_number: '555',
      credit_card_expiration: '10/13',
      result: 'success'
    }}

    it 'creates a Transaction instance' do
      expect { invoice.charge(attributes) }.to change {
        SalesEngine::Models::Transaction.instances.size
      }.from(0).to(1)

      SalesEngine::Models::Transaction.instances.first.tap do |transaction|
        transaction.credit_card_number.should eq '555'
        transaction.credit_card_expiration.should eq '10/13'
        transaction.result.should eq 'success'
      end
    end

    it 'associates the created Transaction instance with the invoice' do
      invoice.charge(attributes).invoice.should eq invoice
    end
  end
end