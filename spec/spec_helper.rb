if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name     'spec:unit'
    add_filter       'config/'
    add_filter       'spec'
    add_filter       '.bundle'
  end
end

require 'rspec'
require 'rspec/its'
require 'bogus/rspec'
require 'virtus'
require 'inflecto' # for resolving namespaced constant names

module Virtus
  def self.warn(*)
    # shut up in tests
  end
end

ENV['TZ'] = 'UTC'

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
