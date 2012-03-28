module SalesEngine
  module Models
    class Invoice
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'invoices.csv'

      def self.average_items
        invoice_item_sizes = InvoiceItem.instances
                                        .group_by(&:invoice_id)
                                        .values.map(&:size)

        average = Helpers.average(invoice_item_sizes)
        Helpers.format_number(average)
      end

      def customer
        Customer.find_by_id(customer_id)
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
    end
  end
end