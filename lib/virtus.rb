require 'ostruct'
require 'backports'

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

  # @api public
  def self.coercer(&block)
    @coercer ||= Coercible::Coercer.new(&block)
  end

end # module Virtus

require 'descendants_tracker'
require 'coercible'

require 'virtus/support/type_lookup'
require 'virtus/support/options'
require 'virtus/support/equalizer'

require 'virtus/extensions'
require 'virtus/class_inclusions'
require 'virtus/module_extensions'

require 'virtus/class_methods'
require 'virtus/instance_methods'

require 'virtus/value_object'

require 'virtus/attribute_set'

require 'virtus/attribute/default_value'
require 'virtus/attribute/default_value/from_clonable'
require 'virtus/attribute/default_value/from_callable'
require 'virtus/attribute/default_value/from_symbol'

require 'virtus/attribute'
require 'virtus/attribute/accessor'
require 'virtus/attribute/reader'
require 'virtus/attribute/writer'
require 'virtus/attribute/writer/coercible'

require 'virtus/attribute/object'
require 'virtus/attribute/class'
require 'virtus/attribute/collection'
require 'virtus/attribute/collection/coercible_writer'
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
require 'virtus/attribute/embedded_value/from_struct'
require 'virtus/attribute/embedded_value/from_open_struct'
