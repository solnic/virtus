require 'pathname'
require 'rubygems'
require 'rspec'

require 'virtus'

ENV['TZ'] = 'UTC'

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path

Pathname.glob((SPEC_ROOT + '**/shared/**/*.rb').to_s).each { |file| require file }

RSpec.configure do |config|

  # Remove anonymous Attribute classes from Attribute descendants
  config.after :all do
    stack = [ Virtus::Attribute ]
    while klass = stack.pop
      klass.descendants.delete_if { |descendant| descendant.name.empty? }
      stack.concat(klass.descendants)
    end
  end

end
