require 'pathname'
require 'rubygems'
require 'rspec'

require 'virtus'

ENV['TZ'] = 'UTC'

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path

Pathname.glob((SPEC_ROOT + '**/shared/**/*.rb').to_s).each { |file| require file }
