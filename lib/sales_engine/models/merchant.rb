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

      def revenue
        total_amount = transactions.select(&:successful?).map {|transaction|
          transaction.invoice.total }.inject(:+)

        Helpers.format_number(total_amount)
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
    end
  end
end