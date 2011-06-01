require 'pathname'
require 'set'
require 'date'
require 'time'
require 'bigdecimal'
require 'bigdecimal/util'

module Virtus
  module Undefined; end

  # @api private
  # TODO: document
  def self.included(base)
    base.extend(Attributes)
    base.extend(Support::Chainable)
  end

  # @api public
  # TODO: document
  def attribute_get(name)
    __send__(name)
  end

  # @api public
  # TODO: document
  def attribute_set(name, value)
    __send__("#{name}=", value)
  end

  # @api public
  # TODO: document
  def attributes=(attributes)
    attributes.each do |name, value|
      if self.class.public_method_defined?(writer_name = "#{name}=")
        __send__(writer_name, value)
      end
    end
  end

  # @api public
  # TODO: document
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
