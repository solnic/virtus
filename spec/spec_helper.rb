require 'pathname'
require 'rubygems'
require 'rspec'

if ENV['SPEC_COV'] && RUBY_VERSION >= '1.9.2'
  require 'simplecov'

  SimpleCov.start do
    add_filter "/spec/"
    add_group "lib", "lib"
  end
end

require 'virtus'

ENV['TZ'] = 'UTC'
