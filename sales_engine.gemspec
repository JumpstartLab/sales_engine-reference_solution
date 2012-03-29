# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Justin Ko"]
  gem.email         = ["justin@kospecinc.com"]
  gem.description   = %q{Reference implementation for Hungry Academy SalesEngine project}
  gem.summary       = %q{Reference implementation for Hungry Academy SalesEngine project}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sales_engine"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.1'

  gem.add_development_dependency 'rspec'
end