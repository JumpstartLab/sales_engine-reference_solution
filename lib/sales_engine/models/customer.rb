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
    end
  end
end