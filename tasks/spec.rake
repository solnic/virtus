begin

  begin
    require 'rspec/core/rake_task'
  rescue LoadError
    require 'spec/rake/spectask'

    module RSpec
      module Core
        RakeTask = Spec::Rake::SpecTask
      end
    end
  end

  desc 'run all specs'
  task :spec => %w[ spec:unit spec:integration ]

  namespace :spec do
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
    t.rcov      = true
    t.rcov_opts = File.read('spec/rcov.opts').split(/\s+/)
  end
rescue LoadError
  task :rcov do
    abort 'rcov is not available. In order to run rcov, you must: gem install rcov'
  end
end

task :test => 'spec'
