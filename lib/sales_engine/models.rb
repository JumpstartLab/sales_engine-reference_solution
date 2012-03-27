module SalesEngine
  module Models
    def self.classes
      @classes ||= []
    end

    def self.clear_instances
      classes.each {|model_class| model_class.instances.clear }
    end
  end
end

require 'sales_engine/models/model'
require 'sales_engine/models/customer'
require 'sales_engine/models/invoice'
require 'sales_engine/models/invoice_item'
require 'sales_engine/models/item'
require 'sales_engine/models/merchant'
require 'sales_engine/models/transaction'