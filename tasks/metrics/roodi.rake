begin
  require 'roodi'
  require 'rake/tasklib'
  require 'roodi_task'

  RoodiTask.new do |t|
    t.verbose  = false
    t.config   = File.expand_path('../../../config/roodi.yml', __FILE__)
    t.patterns = %w[ lib/**/*.rb ]
  end
rescue LoadError
  task :roodi do
    abort 'Roodi is not available. In order to run roodi, you must: gem install roodi'
  end
end
