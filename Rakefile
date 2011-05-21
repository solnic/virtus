require 'rubygems'
require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name        = "virtus"
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["Piotr Solnica"]
  gem.email       = ["piotr@rubyverse.com"]
  gem.homepage    = "https://github.com/solnic/virtus"
  gem.summary     = %q{Add validatable attributes to your ruby objects}
  gem.description = gem.summary

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
end

Jeweler::GemcutterTasks.new
