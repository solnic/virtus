require 'set'
require 'date'
require 'time'
require 'bigdecimal'
require 'bigdecimal/util'
require 'ostruct'

# Base module which adds Attribute API to your classes
module Virtus

  # Provides args for const_get and const_defined? to make them behave
  # consistently across different versions of ruby
  EXTRA_CONST_ARGS = (RUBY_VERSION < '1.9' ? [] : [ false ]).freeze

  # Represents an undefined parameter used by auto-generated option methods
  Undefined = Object.new.freeze

  # Extends base class with class and instance methods
  #
  # @param [Class] descendant
  #
  # @return [undefined]
  #
  # @api private
  def self.included(descendant)
    super
    descendant.extend(ClassMethods)
    descendant.send(:include, InstanceMethods)
  end

  private_class_method :included

end # module Virtus

require 'virtus/support/descendants_tracker'
require 'virtus/support/type_lookup'
require 'virtus/support/options'
require 'virtus/support/equalizer'

require 'virtus/attributes_accessor'
require 'virtus/class_methods'
require 'virtus/instance_methods'

require 'virtus/value_object'

require 'virtus/attribute_set'

require 'virtus/coercion'
require 'virtus/coercion/object'
require 'virtus/coercion/numeric'
require 'virtus/coercion/integer'
require 'virtus/coercion/float'
require 'virtus/coercion/decimal'
require 'virtus/coercion/false_class'
require 'virtus/coercion/true_class'
require 'virtus/coercion/hash'
require 'virtus/coercion/array'
require 'virtus/coercion/time_coercions'
require 'virtus/coercion/date'
require 'virtus/coercion/date_time'
require 'virtus/coercion/time'
require 'virtus/coercion/string'
require 'virtus/coercion/symbol'

require 'virtus/attribute/default_value'
require 'virtus/attribute/default_value/from_clonable'
require 'virtus/attribute/default_value/from_callable'
require 'virtus/attribute/default_value/from_symbol'

require 'virtus/attribute'
require 'virtus/attribute/object'
require 'virtus/attribute/class'
require 'virtus/attribute/collection'
require 'virtus/attribute/array'
require 'virtus/attribute/set'
require 'virtus/attribute/boolean'
require 'virtus/attribute/date'
require 'virtus/attribute/date_time'
require 'virtus/attribute/numeric'
require 'virtus/attribute/decimal'
require 'virtus/attribute/float'
require 'virtus/attribute/hash'
require 'virtus/attribute/integer'
require 'virtus/attribute/symbol'
require 'virtus/attribute/string'
require 'virtus/attribute/time'
require 'virtus/attribute/embedded_value'
