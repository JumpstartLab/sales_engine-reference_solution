require 'sales_engine/models'
require 'sales_engine/csv_parser'
require 'sales_engine/dynamic_finder'

module SalesEngine
  def self.startup(dir_path = './data_sets')
    Models.classes.each do |model_class|
      CSVParser.new(dir_path, model_class::CSV_FILE_NAME).parse do |csv_row|
        model_class.add_instance(csv_row.to_hash)
      end
    end
  end
end