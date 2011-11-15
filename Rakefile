require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

FileList['tasks/**/*.rake'].each { |task| import task }

namespace :spec do
  RSpec::Core::RakeTask.new(:examples) do |t|
    t.pattern = 'examples/**/*_spec.rb'
  end

  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/**/*_spec.rb'
  end

  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = 'spec/unit/**/*_spec.rb'
  end
end

desc 'Default: run specs.'
task :default => ['spec:unit', 'spec:integration', 'spec:examples']
