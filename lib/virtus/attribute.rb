module Virtus

  # Abstract class implementing base API for attribute types
  #
  # @abstract
  class Attribute
    extend DescendantsTracker
    extend TypeLookup
    extend Options

    # Returns name of the attribute
    #
    # @example
    #   User.attributes[:age].name  # => :age
    #
    # @return [Symbol]
    #
    # @api public
    attr_reader :name

    # Returns options hash for the attribute
    #
    # @return [Hash]
    #
    # @api private
    attr_reader :options

    # Returns instance variable name of the attribute
    #
    # @return [String]
    #
    # @api private
    attr_reader :instance_variable_name

    # Returns reader visibility
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :reader_visibility

    # Returns write visibility
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :writer_visibility

    # Returns method name that should be used for coerceing
    #
    # @return [Symbol]
    #
    # @api private
    attr_reader :coercion_method

    # Returns default value
    #
    # @return [Object]
    #
    # @api private
    attr_reader :default

    DEFAULT_ACCESSOR = :public

    OPTIONS = [ :primitive, :accessor, :reader,
                :writer, :coercion_method, :default ].freeze

    accept_options *OPTIONS

    # Initializes an attribute instance
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [#to_hash] options
    #   hash of extra options which overrides defaults set on an attribute class
    #
    # @return [undefined]
    #
    # @api private
    def initialize(name, options = {})
      @name    = name
      @options = self.class.options.merge(options.to_hash).freeze

      @instance_variable_name = "@#{@name}".freeze
      @coercion_method        = @options.fetch(:coercion_method)
      @default                = DefaultValue.new(self, @options[:default])

      set_visibility
    end

    # Returns a concise string representation of the attribute instance
    #
    # @example
    #   attribute = Virtus::Attribute::String.new(:name)
    #   attribute.inspect # => #<Virtus::Attribute::String @name=:name>
    #
    # @return [String]
    #
    # @api public
    def inspect
      "#<#{self.class.name} @name=#{name.inspect}>"
    end

    # Returns value of an attribute for the given instance
    #
    # Sets the default value if an ivar is not set and default
    # value is configured
    #
    # @example
    #   attribute.get(instance)  # => value
    #
    # @return [Object]
    #   value of an attribute
    #
    # @api public
    def get(instance)
      if instance.instance_variable_defined?(instance_variable_name)
        get!(instance)
      else
        set!(instance, default.evaluate(instance))
      end
    end

    # Returns the instance variable of the attribute
    #
    # @example
    #   attribute.get!(instance)  # => value
    #
    # @return [Object]
    #   value of an attribute
    #
    # @api public
    def get!(instance)
      instance.instance_variable_get(instance_variable_name)
    end

    # Sets the value on the instance
    #
    # @example
    #   attribute.set(instance, value)  # => value
    #
    # @return [self]
    #
    # @api public
    def set(instance, value)
      set!(instance, coerce(value))
    end

    # Sets instance variable of the attribute
    #
    # @example
    #   attribute.set!(instance, value)  # => value
    #
    # @return [self]
    #
    # @api public
    def set!(instance, value)
      instance.instance_variable_set(instance_variable_name, value)
    end

    # Converts the given value to the primitive type
    #
    # @example
    #   attribute.coerce(value)  # => primitive_value
    #
    # @param [Object] value
    #   the value
    #
    # @return [Object]
    #   nil, original value or value converted to the primitive type
    #
    # @api public
    def coerce(value)
      Coercion[value.class].send(coercion_method, value)
    end

    # Is the given value coerced into the target type for this attribute?
    #
    # @example
    #   string_attribute = Virtus::Attribute::String.new(:str)
    #   string_attribute.value_coerced?('foo')        # => true
    #   string_attribute.value_coerced?(:foo)         # => false
    #   integer_attribute = Virtus::Attribute::Integer.new(:integer)
    #   integer_attribute.value_coerced?(5)           # => true
    #   integer_attribute.value_coerced?('5')         # => false
    #   date_attribute = Virtus::Attribute::Date.new(:date)
    #   date_attribute.value_coerced?('2011-12-31')   # => false
    #   date_attribute.value_coerced?(Date.today)     # => true
    #
    # @return [Boolean]
    #
    # @api private
    def value_coerced?(value)
      primitives.any? { |primitive| primitive === value }
    end

    # Returns the Set of class(es) to which values will be coerced
    #
    # @return [Set<Object>]
    #
    # @api private
    def primitives
      Set[ *@options.fetch(:primitive) ]
    end

    # Creates an attribute reader method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_reader_method(mod)
      reader_method_name = name
      attribute          = self

      mod.send(:define_method,    reader_method_name) { attribute.get(self) }
      mod.send(reader_visibility, reader_method_name)

      self
    end

    # Creates an attribute writer method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_writer_method(mod)
      writer_method_name = "#{name}="
      attribute          = self

      mod.send(:define_method,    writer_method_name) { |value| attribute.set(self, value) }
      mod.send(writer_visibility, writer_method_name)

      self
    end

  private

    # Sets visibility of reader/write methods based on the options hash
    #
    # @return [undefined]
    #
    # @api private
    def set_visibility
      default_accessor   = @options.fetch(:accessor, self.class::DEFAULT_ACCESSOR)
      @reader_visibility = @options.fetch(:reader,   default_accessor)
      @writer_visibility = @options.fetch(:writer,   default_accessor)
    end

  end # class Attribute
end # module Virtus
