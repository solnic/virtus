require 'date'
require 'time'
require 'bigdecimal'
require 'bigdecimal/util'

# Base module which adds Attribute API to your classes
module Virtus

  # Represents an undefined parameter used by auto-generated option methods
  Undefined = Object.new.freeze

  # Extends base class with class and instance methods
  #
  # @param [Class] base
  #
  # @return [Class]
  #
  # @api private
  def self.included(base)
    base.extend(DescendantsTracker)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  # Returns a Virtus::Attribute::Object sub-class based on a name or class
  #
  # @example
  #   Virtus.determine_type('String') # => Virtus::Attribute::String
  #
  # @param [Class,String] class_or_name
  #   name of a class or a class itself
  #
  # @return [Class]
  #   one of the Virtus::Attribute::Object sub-class
  #
  # @api semipublic
  def self.determine_type(class_or_name)
    if class_or_name.kind_of?(Class)
      if class_or_name < Attribute::Object
        class_or_name
      else
        Attribute.descendants.detect do |descendant|
          class_or_name <= descendant.primitive
        end
      end
    elsif Attribute.const_defined?(name = class_or_name.to_s)
      Attribute.const_get(name)
    end
  end

end # module Virtus

require 'virtus/support/descendants_tracker'

require 'virtus/class_methods'
require 'virtus/instance_methods'

require 'virtus/attribute_set'

require 'virtus/typecast/boolean'
require 'virtus/typecast/numeric'
require 'virtus/typecast/string'
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
