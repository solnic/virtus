source 'https://rubygems.org'

gemspec

group :test do
  gem 'bogus', '~> 0.1'
  gem 'inflecto', '~> 0.0.2'
  gem 'rspec-its', '~> 1.0'
  gem 'rspec-core', '~> 3.1'
  gem 'rspec-expectations', '~> 3.1'
end

group :tools do
  gem 'guard'
  gem 'guard-rspec'

  gem 'rubocop'

  platform :mri do
    gem 'mutant'
    gem 'mutant-rspec'
  end
end
