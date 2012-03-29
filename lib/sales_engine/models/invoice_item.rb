module SalesEngine
  module Models
    class InvoiceItem
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'invoice_items.csv'

      def invoice
        Invoice.find_by_id(invoice_id)
      end

      def item
        Item.find_by_id(item_id)
      end

      def total
        unit_price * quantity
      end
    end
  end
end