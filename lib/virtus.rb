require 'pathname'
require 'set'
require 'date'
require 'time'
require 'bigdecimal'
require 'bigdecimal/util'

module Virtus
  module Undefined; end

  # Extends base class with Attributes and Chainable modules
  #
  # @param [Object] base
  #
  # @api private
  def self.included(base)
    base.extend(Attributes)
    base.extend(Support::Chainable)
  end

  # Returns a value of the attribute with the given name
  #
  # @param [Symbol] name
  #   a name of an attribute
  #
  # @return [Object]
  #   a value of an attribute
  #
  # @api public
  def attribute_get(name)
    __send__(name)
  end


  # Sets a value of the attribute with the given name
  #
  # @param [Symbol] name
  #   a name of an attribute
  #
  # @param [Object] value
  #   a value to be set
  #
  # @return [Object]
  #   the value set on an object
  #
  # @api public
  def attribute_set(name, value)
    __send__("#{name}=", value)
  end

  # Mass-assign of attribute values
  #
  # @param [Hash] attributes
  #   a hash of attribute values to be set on an object
  #
  # @return [Hash]
  #   the attributes
  #
  # @api public
  def attributes=(attributes)
    attributes.each do |name, value|
      if self.class.public_method_defined?(writer_name = "#{name}=")
        __send__(writer_name, value)
      end
    end
  end

  # Returns a hash of all publicly accessible attributes
  #
  # @return [Hash]
  #   the attributes
  #
  # @api public
  def attributes
    attributes = {}

    self.class.attributes.each do |name, attribute|
      if self.class.public_method_defined?(name)
        attributes[name] = __send__(attribute.name)
      end
    end

    attributes
  end
end

dir = Pathname(__FILE__).dirname.expand_path

require dir + 'virtus/support/chainable'
require dir + 'virtus/attributes'
require dir + 'virtus/attributes/typecast/numeric'
require dir + 'virtus/attributes/typecast/time'
require dir + 'virtus/attributes/attribute'
require dir + 'virtus/attributes/object'
require dir + 'virtus/attributes/array'
require dir + 'virtus/attributes/boolean'
require dir + 'virtus/attributes/date'
require dir + 'virtus/attributes/date_time'
require dir + 'virtus/attributes/numeric'
require dir + 'virtus/attributes/decimal'
require dir + 'virtus/attributes/float'
require dir + 'virtus/attributes/hash'
require dir + 'virtus/attributes/integer'
require dir + 'virtus/attributes/string'
require dir + 'virtus/attributes/time'
require dir + 'virtus/dirty_tracking'
require dir + 'virtus/dirty_tracking/session'
