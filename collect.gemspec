# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collect/version'

Gem::Specification.new do |gem|
  gem.name          = "collect"
  gem.version       = Collect::VERSION
  gem.authors       = ["Jeremy Stephens"]
  gem.email         = ["jeremy.f.stephens@vanderbilt.edu"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/viking/collect"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'sinatra'
  gem.add_dependency 'sequel'
  gem.add_dependency 'omniauth'
  gem.add_dependency 'mustache'
  gem.add_dependency 'json'
end
