describe SalesEngine::Models::Merchant do
  include_context 'model examples'

  describe '.most_revenue' do
    {one: 30, two: 20, three: 10}.each do |k, v|
      let("merchant_#{k}") do
        double("merchant_#{k}", revenue: SalesEngine::Helpers.format_number(v))
      end
    end

    before do
      SalesEngine::Models::Merchant.should_receive(:instances) do
        [merchant_three, merchant_two, merchant_one]
      end
    end

    context 'given 2' do
      it 'returns the top 2 merchants in descending order by revenue' do
        SalesEngine::Models::Merchant.most_revenue(2).should =~ [
          merchant_one, merchant_two
        ]
      end
    end
  end

  describe '.most_items' do
    {one: 30, two: 20, three: 10}.each do |k, v|
      let("merchant_#{k}") do
        double("merchant_#{k}", invoices: [
          double(total_items: v), double(total_items: v)
        ])
      end
    end

    before do
      SalesEngine::Models::Merchant.should_receive(:instances) do
        [merchant_three, merchant_two, merchant_one]
      end
    end

    context 'given 2' do
      it 'returns the top 2 merchants in descending order by total items sold' do
        SalesEngine::Models::Merchant.most_items(2).should =~ [
          merchant_one, merchant_two
        ]
      end
    end
  end

  describe '.revenue' do
    context 'given a date' do
      let(:date) { Date.parse('Fri, 09 Mar 2012') }

      before do
        merchant_1 = double.tap do |merchant|
          merchant.should_receive(:revenue).with(date).and_return(500)
        end

        merchant_2 = double.tap do |merchant|
          merchant.should_receive(:revenue).with(date).and_return(500)
        end

        SalesEngine::Models::Merchant.should_receive(:instances) do
          [merchant_1, merchant_2]
        end
      end

      it 'returns the sum of the merchants revenue for the date' do
        revenue = SalesEngine::Models::Merchant.revenue(date)
        revenue.should be_a_big_decimal_equating_to(1000.0)
      end
    end
  end

  describe '#revenue' do
    let!(:merchant) { add_instance(:merchant, id: 1) }
    let(:date) { Date.parse('Fri, 09 Mar 2012') }

    before do
      add_instance(:invoice,
        id: 1, merchant_id: 1, created_at: date.next_day.to_s
      )
      add_instance(:invoice_item, invoice_id: 1, unit_price: 225, quantity: 1)
      add_transaction(invoice_id: 1)

      add_instance(:invoice,
        id: 2, merchant_id: 1, created_at: date.prev_day.to_s
      )
      add_instance(:invoice_item, invoice_id: 2, unit_price: 225, quantity: 1)
      add_transaction(invoice_id: 2)
    end

    context 'given no date' do
      it "returns the sum of the merchant's invoices total amount" do
        merchant.revenue.should be_a_big_decimal_equating_to(450.0)
      end
    end

    context 'given a date' do
      before do
        add_instance(:invoice, id: 3, merchant_id: 1, created_at: date.to_s)
        add_instance(:invoice_item, invoice_id: 3, unit_price: 20, quantity: 1)
        add_transaction(invoice_id: 3)

        add_instance(:invoice, id: 4, merchant_id: 1, created_at: date.to_s)
        add_instance(:invoice_item, invoice_id: 4, unit_price: 30, quantity: 2)
        add_transaction(invoice_id: 4)
      end

      it "returns the sum of the merchant's invoices (created on the date) total amount" do
        merchant.revenue(date).should be_a_big_decimal_equating_to(80.0)
      end
    end
  end

  describe '#items' do
    let!(:merchant) { add_instance(:merchant, id: 1) }
    let!(:matching_item) { add_instance(:item, merchant_id: 1) }
    before { add_instance(:item, merchant_id: 2) }

    it "returns the Item instances whose merchant_id matches the merchant's id" do
      merchant.items.should =~ [matching_item]
    end
  end

  describe '#invoices' do
    let!(:merchant) { add_instance(:merchant, id: 1) }
    let!(:matching_invoice) { add_instance(:invoice, merchant_id: 1) }
    before { add_instance(:invoice, merchant_id: 2) }

    it "returns the Invoice instances whose merchant_id matches the merchant's id" do
      merchant.invoices.should =~ [matching_invoice]
    end
  end

  describe '#transactions' do
    let!(:merchant) { add_instance(:merchant, id: 1) }
    let!(:matching_transaction) { add_transaction(invoice_id: 1) }

    before do
      add_instance(:invoice, id: 1, merchant_id: 1)
      add_instance(:invoice, id: 2, merchant_id: 2)
      add_transaction(invoice_id: 2)
    end

    it "returns the Transaction instances associated with the merchant's invoices" do
      merchant.transactions.should =~ [matching_transaction]
    end
  end

  describe '#favorite_customer' do
    let!(:merchant) { add_instance(:merchant, id: 1) }
    let!(:favorite_customer) { add_instance(:customer, id: 1) }

    before do
      2.times do |i|
        add_instance(:invoice, id: i, customer_id: 1, merchant_id: 1)
        add_transaction(invoice_id: i)
      end

      add_instance(:customer, id: 2)
      add_instance(:invoice, id: 3, customer_id: 2, merchant_id: 1)
      add_transaction(invoice_id: 3)
    end

    it 'returns a Customer instance who has the most successful transactions with the merchant' do
      merchant.favorite_customer.should eq favorite_customer
    end
  end
end