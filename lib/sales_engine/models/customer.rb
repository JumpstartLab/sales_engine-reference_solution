module SalesEngine
  module Models
    class Customer
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'customers.csv'
    end
  end
end