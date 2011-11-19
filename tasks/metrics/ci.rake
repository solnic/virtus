task :ci => %w[ ci:metrics ]

namespace :ci do
  desc 'Run metrics'
  task :metrics => %w[ verify_measurements flog flay reek roodi metrics:all ]
end
