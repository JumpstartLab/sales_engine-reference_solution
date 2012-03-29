module SalesEngine
  module Models
    class Merchant
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'merchants.csv'

      def self.most_revenue(limit)
        instances.sort_by(&:revenue).reverse.take(limit)
      end

      def self.most_items(limit)
        instances.sort_by {|instance|
          instance.invoices.map(&:total_items).inject(:+)
        }.reverse.take(limit)
      end

      def self.revenue(date)
        Helpers.format_number(instances.map {|instance|
          instance.revenue(date) }.inject(:+))
      end

      def self.dates_by_revenue(limit = nil)
      end

      def revenue(date = nil)
        Helpers.format_number(invoices.select {|invoice|
          date ? invoice.created_on?(date) : true
        }.map(&:revenue).inject(:+))
      end

      def items
        Item.find_all_by_merchant_id(id)
      end

      def invoices
        Invoice.find_all_by_merchant_id(id)
      end

      def transactions
        Transaction.find_all_by_invoice_id(invoices.map(&:id))
      end

      def favorite_customer
        transactions.group_by(&:invoice).max_by {|array|
          array.last.size }.first.customer
      end

      def customers_with_pending_invoices
        invoices.reject(&:paid?).map(&:customer)
      end
    end
  end
end