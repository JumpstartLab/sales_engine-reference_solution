module ExampleGroupHelpers
  def add_instance(model_type, attributes = {})
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

  def add_transaction(attributes = {})
    default_attributes = {result: 'success'}
    add_instance(:transaction, default_attributes.merge(attributes))
  end

  def the_date
    Date.parse('Fri, 09 Mar 2012')
  end
end