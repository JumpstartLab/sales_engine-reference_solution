module SalesEngine
  module Models
    class Transaction
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'transactions.csv'
    end
  end
end