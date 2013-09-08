module Virtus

  # Abstract class implementing base API for attribute types
  #
  # @abstract
  class Attribute
    extend DescendantsTracker, Options

    include Adamantium::Flat
    include Equalizer.new(inspect) << :name

    accept_options :primitive, :accessor, :reader,
      :writer, :coercion_method, :default, :lazy

    accessor :public

    # @see Virtus.coerce
    #
    # @deprecated
    #
    # @api public
    def self.coerce(value = Undefined)
      warn "#{self}.coerce is deprecated and will be removed in a future version. Use Virtus.coerce instead: ##{caller.first}"
      return Virtus.coerce if value.equal?(Undefined)
      Virtus.coerce = value
      self
    end

    # Returns name of the attribute
    #
    # @example
    #   User.attributes[:age].name  # => :age
    #
    # @return [Symbol]
    #
    # @api public
    attr_reader :name

    # Return accessor object
    #
    # @return [Accessor]
    #
    # @api private
    attr_reader :accessor

    attr_reader :instance_variable_name

    # Builds an attribute instance
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [Class] type
    #   optional type class of an attribute
    #
    # @param [#to_hash] options
    #   optional extra options hash
    #
    # @return [Attribute]
    #
    # @api private
    def self.build(name, type, options = {})
      Builder.new(name, type, options).attribute
    end

    # Initializes an attribute instance
    #
    # @param [#to_sym] name
    #   the name of an attribute
    #
    # @param [#to_hash] options
    #   hash of extra options which overrides defaults set on an attribute class
    #
    # @return [undefined]
    #
    # @api private
    def initialize(name, accessor)
      @name     = name
      @accessor = accessor
      @instance_variable_name = "@#{@name}"
    end

    # @api public
    def set(instance, value)
      instance.instance_variable_set(instance_variable_name, value)
    end

    # @api public
    def get(instance)
      instance.instance_variable_get(instance_variable_name)
    end

    # Return reader object
    #
    # @example
    #
    #   attribute.reader # => #<Virtus::Attribute::Reader ...>
    #
    # @return [Reader]
    #
    # @api public
    def reader
      accessor.reader
    end

    # Return writer object
    #
    # @example
    #
    #   attribute.writer # => #<Virtus::Attribute::Writer ...>
    #
    # @return [Writer]
    #
    # @api public
    def writer
      accessor.writer
    end

    # Define reader and writer methods for an Attribute
    #
    # @param [AttributeSet] mod
    #
    # @return [self]
    #
    # @api private
    def define_accessor_methods(attribute_set)
      reader.define_method(accessor, attribute_set)
      writer.define_method(accessor, attribute_set)
      self
    end

    # Returns a Boolean indicating whether the reader method is public
    #
    # @return [Boolean]
    #
    # @api private
    def public_reader?
      accessor.public_reader?
    end

    # Returns a Boolean indicating whether the writer method is public
    #
    # @return [Boolean]
    #
    # @api private
    def public_writer?
      accessor.public_writer?
    end

    # Return if the attribute is coercible
    #
    # @return [Boolean]
    #
    # @api public
    def coercible?
      writer.kind_of?(Writer::Coercible)
    end

    # Returns if the given value is coerced into the target type
    #
    # @return [Boolean]
    #
    # @api private
    def value_coerced?(value)
      coercer.coerced?(value)
    end

    # Return coercer for this attribute
    #
    # @return [Object]
    #
    # @api private
    def coercer
      writer.coercer[writer.primitive]
    end

  end # class Attribute

end # module Virtus
