module ExampleGroupHelpers
  def add_instance(model_type, attributes)
    model_class = {
      merchant: 'Merchant',
      invoice: 'Invoice',
      invoice_item: 'InvoiceItem',
      item: 'Item',
      customer: 'Customer',
      transaction: 'Transaction'
    }[model_type]

    SalesEngine::Models.const_get(model_class).add_instance(attributes)
  end
end