desc 'Run metrics with Heckle'
task :ci => %w[ ci:metrics heckle ]

namespace :ci do
  desc 'Run metrics'
  task :metrics => %w[ verify_measurements flog flay reek roodi metrics:all ]
end
