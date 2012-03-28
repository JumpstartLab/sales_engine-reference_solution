module SalesEngine
  module Models
    class Customer
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'customers.csv'

      def invoices
        Invoice.find_all_by_customer_id(id)
      end
    end
  end
end