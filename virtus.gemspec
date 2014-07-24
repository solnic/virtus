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
  gem.license     = 'MIT'

  gem.require_paths    = [ "lib" ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO.md]

  gem.add_dependency('descendants_tracker', '~> 0.0', '>= 0.0.3')
  gem.add_dependency('equalizer',           '~> 0.0', '>= 0.0.9')
  gem.add_dependency('coercible',           '~> 1.0')
  gem.add_dependency('axiom-types',         '~> 0.1')
end
