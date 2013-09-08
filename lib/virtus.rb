require 'ostruct'

# Base module which adds Attribute API to your classes
module Virtus

  # Provides args for const_get and const_defined? to make them behave
  # consistently across different versions of ruby
  EXTRA_CONST_ARGS = (RUBY_VERSION < '1.9' ? [] : [ false ]).freeze

  # Represents an undefined parameter used by auto-generated option methods
  Undefined = Object.new.freeze

  # Extends base class or a module with virtus methods
  #
  # @param [Object] object
  #
  # @return [undefined]
  #
  # @api private
  def self.included(object)
    super
    if Class === object
      object.send(:include, ClassInclusions)
    else
      object.extend(ModuleExtensions)
    end
  end
  private_class_method :included

  # Extends an object with virtus extensions
  #
  # @param [Object] object
  #
  # @return [undefined]
  #
  # @api private
  def self.extended(object)
    object.extend(Extensions)
  end
  private_class_method :extended

  # Sets the global coercer configuration
  #
  # @example
  #   Virtus.coercer do |config|
  #     config.string.boolean_map = { true => '1', false => '0' }
  #   end
  #
  # @return [Coercible::Coercer]
  #
  # @api public
  def self.coercer(&block)
    configuration.coercer(&block)
  end

  # Sets the global coercion configuration value
  #
  # @param [Boolean] value
  #
  # @return [Virtus]
  #
  # @api public
  def self.coerce=(value)
    configuration.coerce = value
    self
  end

  # Returns the global coercion setting
  #
  # @return [Boolean]
  #
  # @api public
  def self.coerce
    configuration.coerce
  end

  # Provides access to the global Virtus configuration
  #
  # @example
  #   Virtus.config do |config|
  #     config.coerce = false
  #   end
  #
  # @return [Configuration]
  #
  # @api public
  def self.config(&block)
    configuration.call(&block)
  end

  # Provides access to the Virtus module builder
  # see Virtus::ModuleBuilder
  #
  # @example
  #   MyVirtusModule = Virtus.module { |mod|
  #     mod.coerce = true
  #     mod.string.boolean_map = { 'yup' => true, 'nope' => false }
  #   }
  #
  #  class Book
  #    include MyVirtusModule
  #
  #    attribute :published, Boolean
  #  end
  #
  #  # This could be made more succinct as well
  #  class OtherBook
  #    include Virtus.module { |m| m.coerce = false }
  #  end
  #
  # @return [Module]
  #
  # @api public
  def self.module(&block)
    ModuleBuilder.call(&block)
  end

  # Global configuration instance
  #
  # @ return [Configuration]
  #
  # @api private
  def self.configuration
    @configuration ||= Configuration.new
  end

end # module Virtus

require 'abstract_type'
require 'descendants_tracker'
require 'adamantium'
require 'axiom-types'
require 'coercible'

require 'virtus/support/options'
require 'virtus/support/equalizer'

require 'virtus/extensions'
require 'virtus/const_missing_extensions'
require 'virtus/class_inclusions'
require 'virtus/module_extensions'

require 'virtus/configuration'
require 'virtus/module_builder'

require 'virtus/class_methods'
require 'virtus/instance_methods'

require 'virtus/value_object'

require 'virtus/attribute_set'

require 'virtus/attribute/default_value'
require 'virtus/attribute/default_value/from_clonable'
require 'virtus/attribute/default_value/from_callable'
require 'virtus/attribute/default_value/from_symbol'

require 'virtus/attribute'
require 'virtus/attribute/builder'
require 'virtus/attribute/coercer'

require 'virtus/attribute/boolean'
require 'virtus/attribute/collection'
require 'virtus/attribute/hash'
require 'virtus/attribute/embedded_value'
require 'virtus/attribute/embedded_value/struct_coercer'
require 'virtus/attribute/embedded_value/open_struct_coercer'
