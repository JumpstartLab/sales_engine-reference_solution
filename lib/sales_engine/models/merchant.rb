module SalesEngine
  module Models
    class Merchant
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'merchants.csv'

      def items
        Item.find_all_by_merchant_id(@id)
      end

      def invoices
        Invoice.find_all_by_merchant_id(@id)
      end
    end
  end
end