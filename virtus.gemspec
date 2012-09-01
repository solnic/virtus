# -*- encoding: utf-8 -*-

require File.expand_path('../lib/virtus/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "virtus"
  gem.version     = Virtus::VERSION
  gem.authors     = [ "Piotr Solnica" ]
  gem.email       = [ "piotr.solnica@gmail.com" ]
  gem.description = "Attributes on Steroids for Plain Old Ruby Objects"
  gem.summary     = gem.description
  gem.homepage    = "https://github.com/solnic/virtus"

  gem.require_paths    = [ "lib" ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]

  gem.add_runtime_dependency('backports', '~> 2.6.1')

  gem.add_development_dependency('rake',        '~> 0.9.2')
  gem.add_development_dependency('rspec',       '~> 2.11.0')
  gem.add_development_dependency('guard-rspec', '~> 1.2.1')
end
