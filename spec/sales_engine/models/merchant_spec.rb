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

    context 'given a limit of 2' do
      it 'returns the top 2 Merchant instances in descending order by revenue' do
        SalesEngine::Models::Merchant.most_revenue(2).should eq [
          merchant_one, merchant_two
        ]
      end
    end
  end

  describe '.most_items' do
    {one: 30, two: 20, three: 10}.each do |k, v|
      let("merchant_#{k}") do
        double("merchant_#{k}", invoices: 2.times.map { double(total_items: v) })
      end
    end

    before do
      SalesEngine::Models::Merchant.should_receive(:instances) do
        [merchant_three, merchant_two, merchant_one]
      end
    end

    context 'given a limit of 2' do
      it 'returns the top 2 Merchant instances in descending order by total items sold' do
        SalesEngine::Models::Merchant.most_items(2).should eq [
          merchant_one, merchant_two
        ]
      end
    end
  end

  describe '.revenue' do
    context 'given a date' do
      let(:date) { the_date }

      before do
        SalesEngine::Models::Merchant.should_receive(:instances) do
          2.times.map do
            double.tap do |merchant|
              merchant.should_receive(:revenue).with(date).and_return(500)
            end
          end
        end
      end

      it 'returns the sum of the merchants revenue for the date' do
        revenue = SalesEngine::Models::Merchant.revenue(date)
        revenue.should be_a_big_decimal_equating_to(1000.0)
      end
    end
  end

  pending '.dates_by_revenue' do
    context 'given a limit of 2' do
      it 'returns the top 2 Date instances with the higest revenue in descending order' do
        dates_by_revenue = SalesEngine::Models::Merchant.dates_by_revenue(2)
        dates_by_revenue.should eq []
      end
    end

    context 'given no limit' do
      it 'returns Date instances in descending order by highest revenue' do
        dates_by_revenue = SalesEngine::Models::Merchant.dates_by_revenue
        dates_by_revenue.should eq []
      end
    end
  end

  describe '#revenue' do
    let(:merchant) { add_instance(:merchant) }

    context 'given no date' do
      before do
        merchant.should_receive(:invoices) { 2.times.map {
          double(revenue: 225)
        }}
      end

      it "returns the sum of the merchant's invoices total amount" do
        merchant.revenue.should be_a_big_decimal_equating_to(450.0)
      end
    end

    context 'given a date' do
      let(:date) { the_date }

      before do
        merchant.should_receive(:invoices) { 2.times.map {
          double(revenue: 225).tap {|invoice|
            invoice.should_receive(:created_on?).with(date).and_return(true)
          }
        }}
      end

      it "returns the sum of the merchant's invoices (created on the date) total amount" do
        merchant.revenue(date).should be_a_big_decimal_equating_to(450.0)
      end
    end
  end

  describe '#items' do
    let!(:merchant) { add_instance(:merchant, id: 1) }
    let!(:matching_item) { add_instance(:item, merchant_id: 1) }
    before { add_instance(:item, merchant_id: 2) }

    it "returns the Item instances whose merchant_id matches the merchant's id" do
      merchant.items.should eq [matching_item]
    end
  end

  describe '#invoices' do
    let!(:merchant) { add_instance(:merchant, id: 1) }
    let!(:matching_invoice) { add_instance(:invoice, merchant_id: 1) }
    before { add_instance(:invoice, merchant_id: 2) }

    it "returns the Invoice instances whose merchant_id matches the merchant's id" do
      merchant.invoices.should eq [matching_invoice]
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
      merchant.transactions.should eq [matching_transaction]
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

  describe '#customers_with_pending_invoices' do
    let(:merchant) { add_instance(:merchant, id: 1) }
    let(:customer_one) { add_instance(:customer, id: 1) }
    let(:customer_two) { add_instance(:customer, id: 2) }

    before do
      merchant.should_receive(:invoices) {[
        double(paid?: false, customer: customer_one),
        double(paid?: false, customer: customer_two),
        double(paid?: true)
      ]}
    end

    it 'returns Customer instances who have unpaid invoices with the merchant' do
      merchant.customers_with_pending_invoices.should eq [
        customer_one, customer_two
      ]
    end
  end
end