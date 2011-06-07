begin
  require 'flog'
  require 'yaml'

  class Float
    def round_to(n)
      (self * 10**n).round.to_f * 10**-n
    end
  end

  config    = YAML.load_file(File.expand_path('../../../config/flog.yml', __FILE__)).freeze
  threshold = config.fetch('threshold').to_f.round_to(1)

  # original code by Marty Andrews:
  # http://blog.martyandrews.net/2009/05/enforcing-ruby-code-quality.html
  desc 'Analyze for code complexity'
  task :flog do
    flog = Flog.new
    flog.flog Array(config.fetch('path', 'lib'))

    totals = flog.totals.select  { |name, score| name[-5, 5] != '#none' }.
                         map     { |name, score| [ name, score.round_to(1) ] }.
                         sort_by { |name, score| score }

    max = totals.last[1]
    unless max >= threshold
      raise "Adjust flog score down to #{max}"
    end

    bad_methods = totals.select { |name, score| score > threshold }
    if bad_methods.any?
      bad_methods.reverse_each do |name, score|
        puts '%8.1f: %s' % [ score, name ]
      end

      raise "#{bad_methods.size} methods have a flog complexity > #{threshold}"
    end
  end
rescue LoadError
  task :flog do
    abort 'Flog is not available. In order to run flog, you must: gem install flog'
  end
end
