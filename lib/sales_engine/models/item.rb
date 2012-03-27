module SalesEngine
  module Models
    class Item
      include SalesEngine::Models::Model

      CSV_FILE_NAME = 'items.csv'
    end
  end
end