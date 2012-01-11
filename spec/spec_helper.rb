require 'backports'
require 'rubygems'
require 'rspec'

require 'virtus'

ENV['TZ'] = 'UTC'

# require spec support files and shared behavior
Dir[File.expand_path('../**/shared/**/*.rb', __FILE__)].each { |file| require file }

RSpec.configure do |config|

  # Remove anonymous Attribute classes from Attribute descendants
  config.after :all do
    stack = [ Virtus::Attribute ]
    while klass = stack.pop
      klass.descendants.delete_if do |descendant|
        descendant.name.nil? || descendant.name.empty?
      end
      stack.concat(klass.descendants)
    end
  end

end
