require 'rubygems'
require 'rake'
require 'jeweler'
require 'rspec/core/rake_task'

Jeweler::Tasks.new do |gem|
  gem.name        = 'virtus'
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = [ 'Piotr Solnica' ]
  gem.email       = [ 'piotr@rubyverse.com' ]
  gem.homepage    = 'https://github.com/solnic/virtus'
  gem.summary     = 'Attributes for your plain ruby objects'
  gem.description = gem.summary
end

Jeweler::GemcutterTasks.new

FileList['tasks/**/*.rake'].each { |task| import task }

desc 'Default: run specs.'
task :default => :spec
