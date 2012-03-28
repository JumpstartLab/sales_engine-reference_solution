require 'csv'

module SalesEngine
  class CSVParser
    def initialize(directory_path, file_name)
      @csv_path = File.join(directory_path, file_name)
    end

    def parse
      CSV.foreach(@csv_path,
        headers: :first_row,
        converters: :all,
        header_converters:
        :symbol
      ) {|row| yield row }
    end
  end
end