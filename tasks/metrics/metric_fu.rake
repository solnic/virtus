begin
  require 'metric_fu'
  require 'json'

  # XXX: temporary hack until metric_fu is fixed
  MetricFu::Saikuro.class_eval { include FileUtils }

  MetricFu::Configuration.run do |config|
    config.rcov = {
      :environment => 'test',
      :test_files  => %w[ spec/**/*_spec.rb ],
      :rcov_opts   => %w[
        --sort coverage
        --no-html
        --text-coverage
        --no-color
        --profile
        --exclude spec/,^/
        --include lib:spec
      ],
    }
  end
rescue LoadError
  namespace :metrics do
    task :all do
      abort 'metric_fu is not available. In order to run metrics:all, you must: gem install metric_fu'
    end
  end
end
