module ExampleGroupHelpers
  def add_instance(model_type, attributes)
    model_class = {
      merchant: 'Merchant',
      invoice: 'Invoice',
      item: 'Item',
      customer: 'Customer'
    }[model_type]

    SalesEngine::Models.const_get(model_class).add_instance(attributes)
  end
end