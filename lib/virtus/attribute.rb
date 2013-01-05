module Virtus

  # Abstract class implementing base API for attribute types
  #
  # @abstract
  class Attribute
    extend DescendantsTracker, TypeLookup, Options

    include Equalizer.new(inspect) << :name

    accept_options :primitive, :accessor, :reader,
      :writer, :coerce, :coercion_method, :default

    accessor :public
    coerce true

    # Returns name of the attribute
    #
    # @example
    #   User.attributes[:age].name  # => :age
    #
    # @return [Symbol]
    #
    #  public
    attr_reader :name

    attr_reader :accessor

    attr_reader :default

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
    def self.build(name, type = Object, options = {})
      klass = determine_type(type)

      unless klass
        raise ArgumentError, "#{type.inspect} does not map to an attribute type"
      end

      attribute_options = klass.merge_options(type, options)

      reader_class = options.fetch(:reader_class) { klass.reader_class(type, attribute_options) }
      writer_class = options.fetch(:writer_class) { klass.writer_class(type, attribute_options) }

      reader   = reader_class.new(name, attribute_options[:reader])
      writer   = writer_class.new(name, attribute_options[:writer], klass.writer_options(attribute_options))
      accessor = Accessor.new(reader, writer)

      klass.new(name, accessor, attribute_options[:default])
    end

    # @api private
    def self.reader_class(*)
      Reader
    end

    # @api private
    def self.writer_class(type, options)
      options[:coerce] ? coercible_writer_class(type, options) : Writer
    end

    # @api private
    def self.coercible_writer_class(type, options)
      Writer::Coercible
    end

    # Return options accepted by Writer
    #
    # @return [Array<Symbol>]
    #
    # @api private
    def self.writer_options(attribute_options)
      writer_option_names.each_with_object({}) { |key, options|
        options[key] = attribute_options[key]
      }
    end

    # @api private
    def self.writer_option_names
      [ :coercer, :coercion_method, :primitive ]
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
        EmbeddedValue.determine_type(class_or_name) or super
      when ::String
        super
      when ::Enumerable
        super(class_or_name.class)
      else
        super
      end
    end

    # Determine visibility of reader/write methods based on the options hash
    #
    # @return [::Hash]
    #
    # @api private
    def self.determine_visibility(options)
      default_accessor  = options.fetch(:accessor)
      reader_visibility = options.fetch(:reader, default_accessor)
      writer_visibility = options.fetch(:writer, default_accessor)

      { :reader => reader_visibility, :writer => writer_visibility }
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
      base_options = self.options.merge(options)
      base_options.update(determine_visibility(base_options))
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
    def initialize(name, accessor, default = nil)
      @name     = name.to_sym
      @accessor = accessor
      @default  = DefaultValue.build(default)
    end

    # @api public
    def coerce?
      @coerce
    end

    # @api public
    def coerce(value)
      accessor.writer.coerce(value)
    end

    # Is the given value coerced into the target type for this attribute?
    #
    # @return [Boolean]
    #
    # @api private
    def value_coerced?(value)
      accessor.primitive === value
    end

    # Define reader and writer methods for an Attribute
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_accessor_methods(mod)
      define_reader_method(mod)
      define_writer_method(mod)
      self
    end

    # @api private
    def get(instance)
      if instance.instance_variable_defined?(accessor.reader.instance_variable_name)
        accessor.reader.get(instance)
      else
        value = default.call(instance, self)
        accessor.writer.set(instance, value)
        value
      end
    end

    # Creates an attribute reader method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_reader_method(mod)
      reader = accessor.reader
      mod.define_reader_method(self, reader.name, reader.visibility)
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
      writer = accessor.writer
      mod.define_writer_method(writer, writer.name, writer.visibility)
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

  end # class Attribute

end # module Virtus
