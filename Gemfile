source 'https://rubygems.org'

gemspec

group :test do
  gem 'bogus', '~> 0.1'
  gem 'inflecto', '~> 0.0.2'
  gem 'rspec', '~> 3.1'
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
