# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_fannable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ravikiran"]
  gem.email         = ["ravikiran@heurion.com"]
  gem.description   = %q{Test Gem}
  gem.summary       = %q{Test Gem}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "acts_as_fannable"
  gem.require_paths = ["lib"]
  gem.add_development_dependency "rspec","~> 2.3"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "sqlite3-ruby"
  gem.add_development_dependency "shoulda-matchers"
  gem.add_dependency "activerecord", "~> 3.0"
  gem.version       = ActsAsFannable::VERSION
end

