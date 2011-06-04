require 'pathname'
require 'set'
require 'date'
require 'time'
require 'bigdecimal'
require 'bigdecimal/util'

module Virtus
  module Undefined; end

  class << self
    # Extends base class with Attributes and Chainable modules
    #
    # @param [Object] base
    #
    # @api private
    def included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.extend(Support::Chainable)
    end

    # Returns a Virtus::Attributes::Object sub-class based on a name or class.
    #
    # @param [Class,String] class_or_name
    #   name of a class or a class itself
    #
    # @return [Class]
    #   one of the Virtus::Attributes::Object sub-class
    #
    # @api semipublic
    def determine_type(class_or_name)
      if class_or_name.is_a?(Class) && class_or_name < Attributes::Object
        class_or_name
      elsif Attributes.const_defined?(name = class_or_name.to_s)
        Attributes.const_get(name)
      end
    end
  end
end

dir = Pathname(__FILE__).dirname.expand_path

require dir + 'virtus/support/chainable'
require dir + 'virtus/class_methods'
require dir + 'virtus/instance_methods'
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
