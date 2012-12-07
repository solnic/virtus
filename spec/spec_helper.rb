require 'rspec'
require 'virtus'

ENV['TZ'] = 'UTC'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

# require spec support files and shared behavior
Dir[File.expand_path('../shared/**/*.rb', __FILE__)].each { |file| require file }

RSpec.configure do |config|

  # Remove anonymous- and example- Attribute classes from Attribute descendants
  config.after :all do
    stack = [ Virtus::Attribute ]
    while klass = stack.pop
      klass.descendants.delete_if do |descendant|
        descendant.name.nil? || descendant.name.empty? || descendant.name.start_with?('Examples::')
      end
      stack.concat(klass.descendants)
    end
  end

  # Remove constants in the Example-Module
  config.after :each do
    if defined?(Examples)
      Examples.constants.each do |const_name|
        ConstantsHelpers.undef_constant(Examples, const_name)
      end
    end
  end

end
