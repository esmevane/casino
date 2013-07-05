# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'casino/version'

Gem::Specification.new do |gem|

  gem.name          = "mongoid-casino"
  gem.version       = Casino::VERSION
  gem.authors       = ["JC McCormick"]
  gem.email         = ["esmevane@gmail.com"]
  gem.description   = %q{Create and maintain aggregate metadata with Mongoid}
  gem.summary       = %q{Aggregation handler for Mongoid}
  gem.homepage      = "http://www.github.com/esmevane/casino"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "mongoid", "3.0.19"

  gem.add_development_dependency "database_cleaner", "~> 0.9"
  gem.add_development_dependency "fabrication", "~> 2.6"
  gem.add_development_dependency "json", "~> 1.7"
  gem.add_development_dependency "minitest", "~> 4.3"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "simplecov", "~> 0.7"

end
