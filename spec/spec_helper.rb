require 'sales_engine'

Dir['./spec/support/**/*.rb'].map {|file| require file }

RSpec.configure do |config|
  config.include ExampleGroupHelpers
  config.before { SalesEngine::Models.clear_instances }
end