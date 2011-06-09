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
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.extend(Support::Chainable)
  end

  # Returns a Virtus::Attributes::Object sub-class based on a name or class
  #
  # @param [Class,String] class_or_name
  #   name of a class or a class itself
  #
  # @return [Class]
  #   one of the Virtus::Attributes::Object sub-class
  #
  # @api semipublic
  def self.determine_type(class_or_name)
    if class_or_name.is_a?(Class) && class_or_name < Attribute::Object
      class_or_name
    elsif Attribute.const_defined?(name = class_or_name.to_s)
      Attribute.const_get(name)
    end
  end
end

require 'virtus/support/chainable'
require 'virtus/class_methods'
require 'virtus/instance_methods'

require 'virtus/typecast/boolean'
require 'virtus/typecast/numeric'
require 'virtus/typecast/time'

require 'virtus/attribute'
require 'virtus/attribute/object'
require 'virtus/attribute/array'
require 'virtus/attribute/boolean'
require 'virtus/attribute/date'
require 'virtus/attribute/date_time'
require 'virtus/attribute/numeric'
require 'virtus/attribute/decimal'
require 'virtus/attribute/float'
require 'virtus/attribute/hash'
require 'virtus/attribute/integer'
require 'virtus/attribute/string'
require 'virtus/attribute/time'
