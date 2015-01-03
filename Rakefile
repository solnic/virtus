require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)
task default: [:spec]

begin
  require "rubocop/rake_task"

  Rake::Task[:default].enhance [:rubocop]

  RuboCop::RakeTask.new do |task|
    task.options << "--display-cop-names"
  end
rescue LoadError
end
