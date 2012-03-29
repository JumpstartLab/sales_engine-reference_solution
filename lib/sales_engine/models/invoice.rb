module SalesEngine
  module Models
    class Invoice
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'invoices.csv'

      def self.pending
        instances.reject(&:paid?)
      end

      def self.average_items(date = nil)
        Helpers.format_average(instances.select {|instance|
          date ? instance.created_on?(date) : true
        }.map(&:total_items_count))
      end

      def self.average_revenue(date = nil)
        Helpers.format_average(instances.select {|instance|
          date ? instance.created_on?(date) : true
        }.map(&:revenue))
      end

      def customer
        Customer.find_by_id(customer_id)
      end

      def merchant
        Merchant.find_by_id(merchant_id)
      end

      def invoice_items
        InvoiceItem.find_all_by_invoice_id(id)
      end

      def items
        Item.find_all_by_id(invoice_items.map(&:item_id))
      end

      def transactions
        Transaction.find_all_by_invoice_id(id)
      end

      def total_amount
        invoice_items.map(&:total_amount).inject(:+)
      end

      def total_items_count
        invoice_items.map(&:quantity).inject(:+)
      end

      def paid?
        transactions.any?(&:successful?)
      end

      def revenue
        paid? ? total_amount : 0
      end
    end
  end
end