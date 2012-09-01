source 'https://rubygems.org'

gemspec

group :metrics do
  gem 'fattr',       '~> 2.2.0'
  gem 'arrayfields', '~> 4.7.4'
  gem 'flay',        '~> 1.4.2'
  gem 'flog',        '~> 2.5.1'
  gem 'map',         '~> 5.2.0'
  gem 'reek',        '~> 1.2.8', :git => 'git://github.com/dkubb/reek.git'
  gem 'roodi',       '~> 2.1.0'
  gem 'yardstick',   '~> 0.4.0'

  platforms :mri_18 do
    gem 'heckle',    '~> 1.4.3'
    gem 'json',      '~> 1.7'
    gem 'metric_fu', '~> 2.1.1'
    gem 'mspec',     '~> 1.5.17'
    gem 'rcov',      '~> 0.9.9'
    gem 'ruby2ruby', '=  1.2.2'
  end

  platforms :rbx do
    gem 'pelusa', :git => 'https://github.com/codegram/pelusa.git'
  end
end
