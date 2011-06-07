begin
  require 'flay'
  require 'yaml'

  config      = YAML.load_file(File.expand_path('../../../config/flay.yml', __FILE__)).freeze
  threshold   = config.fetch('threshold').to_i
  total_score = config.fetch('total_score').to_f
  files       = Flay.expand_dirs_to_files(config.fetch('path', 'lib'))

  # original code by Marty Andrews:
  # http://blog.martyandrews.net/2009/05/enforcing-ruby-code-quality.html
  desc 'Analyze for code duplication'
  task :flay do
    # run flay once without a threshold to ensure the max mass matches the threshold
    flay = Flay.new(:fuzzy => false, :verbose => false, :mass => 0)
    flay.process(*files)

    max = flay.masses.map { |hash, mass| mass.to_f / flay.hashes[hash].size }.max
    unless max >= threshold
      raise "Adjust flay threshold down to #{max}"
    end

    total = flay.masses.reduce(0.0) { |total, (hash, mass)| total + (mass.to_f / flay.hashes[hash].size) }
    unless total == total_score
      raise "Flay total is now #{total}, but expected #{total_score}"
    end

    # run flay a second time with the threshold set
    flay = Flay.new(:fuzzy => false, :verbose => false, :mass => threshold.succ)
    flay.process(*files)

    if flay.masses.any?
      flay.report
      raise "#{flay.masses.size} chunks of code have a duplicate mass > #{threshold}"
    end
  end
rescue LoadError
  task :flay do
    abort 'Flay is not available. In order to run flay, you must: gem install flay'
  end
end
