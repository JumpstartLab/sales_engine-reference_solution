RSpec::Matchers.define :all_be_an_instance_of do |expected_class|
  match do |instances|
    instances.all? {|instance| instance.is_a?(expected_class) }
  end
end