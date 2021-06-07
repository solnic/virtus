source 'https://rubygems.org'

gemspec

gem 'bogus', '~> 0.1'
gem 'dry-inflector'
gem 'rspec', '~> 3.1'

gem "codeclimate-test-reporter", group: :test, require: false

group :tools do
  gem 'guard'
  gem 'guard-rspec'

  gem 'rubocop'

  platform :mri do
    gem 'mutant'
    gem 'mutant-rspec'
  end
end
