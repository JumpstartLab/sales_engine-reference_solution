module SalesEngine
  module Models
    class Transaction
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'transactions.csv'

      def invoice
        Invoice.find_by_id(invoice_id)
      end
    end
  end
end