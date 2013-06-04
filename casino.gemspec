# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'casino/version'

Gem::Specification.new do |gem|

  gem.name          = "casino"
  gem.version       = Casino::VERSION
  gem.authors       = ["JC McCormick"]
  gem.email         = ["esmevane@gmail.com"]
  gem.description   = %q{Create and maintain aggregate data with Mongoid}
  gem.summary       = %q{Map reduce handler for Mongoid}
  gem.homepage      = "http://www.github.com/acumenbrands/casino"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "mongoid", "3.0.19"

  gem.add_development_dependency "minitest", "4.3.3"
  gem.add_development_dependency "database_cleaner", "0.9.1"
  gem.add_development_dependency "fabrication", "2.6.5"
  gem.add_development_dependency "rake", "10.0.4"

end
