module SalesEngine
  module Models
    class InvoiceItem
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'invoice_items.csv'
    end
  end
end