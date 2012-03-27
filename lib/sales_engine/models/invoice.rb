module SalesEngine
  module Models
    class Invoice
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'invoices.csv'

      def customer
        Customer.find_by_id(@customer_id)
      end
    end
  end
end