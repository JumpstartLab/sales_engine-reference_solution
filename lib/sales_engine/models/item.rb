module SalesEngine
  module Models
    class Item
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'items.csv'

      def invoice_items
        InvoiceItem.find_all_by_item_id(id)
      end

      def invoices
        Invoice.find_all_by_id(invoice_items.map(&:invoice_id))
      end

      def best_day
        invoices.group_by {|invoice| invoice.created_at.to_date }.
                 max_by {|array| array.last.size }.first
      end
    end
  end
end