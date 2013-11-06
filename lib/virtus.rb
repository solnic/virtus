require 'ostruct'

# Base module which adds Attribute API to your classes
module Virtus

  # Provides args for const_get and const_defined? to make them behave
  # consistently across different versions of ruby
  EXTRA_CONST_ARGS = (RUBY_VERSION < '1.9' ? [] : [ false ]).freeze

  # Represents an undefined parameter used by auto-generated option methods
  Undefined = Object.new.freeze

  class CoercionError < StandardError
    attr_reader :output, :primitive

    def initialize(output, primitive)
      @output, @primitive = output, primitive
      super("Failed to coerce #{output.inspect} into #{primitive.inspect}")
    end
  end

  # Extends base class or a module with virtus methods
  #
  # @param [Object] object
  #
  # @return [undefined]
  #
  # @deprecated
  #
  # @api private
  def self.included(object)
    super
    if Class === object
      Virtus.warn("including Virtus module is deprecated. Use 'include Virtus.model' instead #{caller.first}")
      object.send(:include, ClassInclusions)
    else
      Virtus.warn("including Virtus module is deprecated. Use 'include Virtus.module' instead #{caller.first}")
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
  # @deprecated
  #
  # @api private
  def self.extended(object)
    Virtus.warn("extending with Virtus module is deprecated. Use 'extend(Virtus.model)' instead #{caller.first}")
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
  def self.model(options = {}, &block)
    ModelBuilder.call(options, &block)
  end

  # Builds a module for...modules
  #
  # @example
  #
  #   module Common
  #     include Virtus.module
  #
  #     attribute :name, String
  #     attribute :age,  Integer
  #   end
  #
  #   class User
  #     include Common
  #   end
  #
  #   class Admin
  #     include Common
  #   end
  #
  # @return [Module]
  #
  # @api public
  def self.module(options = {}, &block)
    ModuleBuilder.call(options, &block)
  end

  # Builds a module for value object models
  #
  # @example
  #
  #   class GeoLocation
  #     include Virtus.value_object
  #
  #     values do
  #       attribute :lat, Float
  #       attribute :lng, Float
  #     end
  #   end
  #
  # @return [Module]
  #
  # @api public
  def self.value_object(options = {}, &block)
    ValueObjectBuilder.call(options, &block)
  end

  # Global configuration instance
  #
  # @ return [Configuration]
  #
  # @api private
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Finalize pending attributes
  #
  # @example
  #   class User
  #     include Virtus.model(:finalize => false)
  #
  #     attribute :address, 'Address'
  #   end
  #
  #   class Address
  #     include Virtus.model(:finalize => false)
  #
  #     attribute :user, 'User'
  #   end
  #
  #   Virtus.finalize # this will resolve constant names
  #
  # @return [Array] array of finalized models
  #
  # @api public
  def self.finalize
    Builder.pending.each do |klass|
      klass.attribute_set.finalize
    end
  end

  # @api private
  def self.warn(msg)
    Kernel.warn(msg)
  end

end # module Virtus

require 'descendants_tracker'
require 'equalizer'
require 'axiom-types'
require 'coercible'

require 'virtus/support/equalizer'
require 'virtus/support/options'
require 'virtus/support/type_lookup'

require 'virtus/model'
require 'virtus/extensions'
require 'virtus/const_missing_extensions'
require 'virtus/class_inclusions'
require 'virtus/module_extensions'

require 'virtus/configuration'
require 'virtus/builder'
require 'virtus/builder/hook_context'

require 'virtus/class_methods'
require 'virtus/instance_methods'

require 'virtus/value_object'

require 'virtus/coercer'
require 'virtus/attribute_set'

require 'virtus/attribute/default_value'
require 'virtus/attribute/default_value/from_clonable'
require 'virtus/attribute/default_value/from_callable'
require 'virtus/attribute/default_value/from_symbol'

require 'virtus/attribute'
require 'virtus/attribute/builder'
require 'virtus/attribute/coercer'
require 'virtus/attribute/accessor'
require 'virtus/attribute/coercible'
require 'virtus/attribute/strict'
require 'virtus/attribute/lazy_default'

require 'virtus/attribute/boolean'
require 'virtus/attribute/collection'
require 'virtus/attribute/hash'
require 'virtus/attribute/embedded_value'
