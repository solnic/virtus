source 'https://rubygems.org'

gemspec

gem 'bogus', '~> 0.1'
gem 'inflecto', '~> 0.0.2'
gem 'rspec', '~> 3.1'

group :development, :test do
  gem 'rubocop', '0.35.1'
end

group :test do
  gem 'codeclimate-test-reporter', :require => false
end

group :tools do
  gem 'guard'
  gem 'guard-rspec'

  platform :mri do
    gem 'mutant'
    gem 'mutant-rspec'
  end
end
