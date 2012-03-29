module SalesEngine
  module Models
    class Customer
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'customers.csv'

      def invoices
        Invoice.find_all_by_customer_id(id)
      end

      def transactions
        invoices.map(&:transactions).flatten
      end

      def favorite_merchant
        invoices.group_by(&:merchant).max_by {|array| array.last.size }.first
      end
    end
  end
end