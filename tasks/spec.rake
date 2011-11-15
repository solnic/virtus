begin
  require 'rspec/core/rake_task'

  desc 'run all specs'
  task :spec => ['spec:unit', 'spec:integration', 'spec:examples']

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
rescue LoadError
  task :spec do
    abort 'rspec is not available. In order to run spec, you must: gem install rspec'
  end
end

begin
  desc "Generate code coverage"
  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.rcov_opts = File.read('spec/rcov.opts').split(/\s+/)
  end
rescue LoadError
  %w[ rcov verify_rcov ].each do |name|
    task name do
      abort "rcov is not available. In order to run #{name}, you must: gem install rcov"
    end
  end
end

task :test    => 'spec'
