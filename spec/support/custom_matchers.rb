RSpec::Matchers.define :all_be_an_instance_of do |expected_class|
  match do |instances|
    instances.all? {|instance| instance.is_a?(expected_class) }
  end
end

RSpec::Matchers.define :be_a_big_decimal_equating_to do |expected_big_decimal|
  match do |big_decimal|
    BigDecimal === big_decimal && big_decimal == expected_big_decimal
  end
end