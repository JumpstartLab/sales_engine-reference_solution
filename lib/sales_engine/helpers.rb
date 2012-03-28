require 'bigdecimal'

module SalesEngine
  module Helpers
    def self.format_number(number)
      BigDecimal.new("%.2f" % number)
    end

    def self.average(array)
      array.inject(:+).to_f / array.size
    end
  end
end