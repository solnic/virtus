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
    # @return [Symbol]
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

    # Builds an attribute instance
    #
    # @param [Symbol] name
    #   the name of an attribute
    #
    # @param [Class] type
    #   the type class of an attribute
    #
    # @param [#to_hash] options
    #   the extra options hash
    #
    # @return [Attribute]
    #
    # @api private
    def self.build(name, type, options = {})
      attribute_class   = determine_type(type)
      attribute_options = attribute_class.merge_options(type, options)
      attribute_class.new(name, attribute_options)
    end

    # Determine attribute type based on class or name
    #
    # Returns Attribute::EmbeddedValue if a virtus class is passed
    #
    # @example
    #   address_class = Class.new { include Virtus }
    #   Virtus::Attribute.determine_type(address_class) # => Virtus::Attribute::EmbeddedValue
    #
    # @see Virtus::Support::TypeLookup.determine_type
    #
    # @return [Class]
    #
    # @api public
    def self.determine_type(class_or_name)
      case class_or_name
      when ::Class
        if class_or_name <= Virtus
          Attribute::EmbeddedValue
        else
          super
        end
      when *Attribute::Collection.descendants.map { |a| a.primitive }
        super(class_or_name.class)
      else
        super
      end
    end

    # A hook for Attributes to update options based on the type from the caller
    # 
    # @param [Object] type
    #   The raw type, typically given by the caller of ClassMethods#attribute
    # @param [Hash] options
    #   Attribute configuration options
    # 
    # @return [Hash]
    #   New Hash instance, potentially updated with information from the args
    # 
    # @api private
    # 
    # @todo add type arg to Attribute#initialize signature and handle there?
    def self.merge_options(type, options)
      options
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
    def initialize(name, options = {})
      @name    = name.to_sym
      @options = self.class.options.merge(options.to_hash).freeze

      @instance_variable_name = "@#{@name}".to_sym
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

    # Define reader and writer methods for an Attribute
    #
    # @param [Attribute] attribute
    #
    # @return [self]
    #
    # @api private
    def define_accessor_methods(mod)
      define_reader_method(mod)
      define_writer_method(mod)
      self
    end

    # Creates an attribute reader method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_reader_method(mod)
      mod.define_reader_method(self, name, reader_visibility)
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
      mod.define_writer_method(self, "#{name}=", writer_visibility)
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
