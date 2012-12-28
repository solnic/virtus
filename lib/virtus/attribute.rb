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
    # @api public
    attr_reader :name

    attr_reader :accessor

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
      attribute_class = determine_type(type)

      attribute_options = attribute_class.options.merge(options)
      attribute_options = attribute_class.merge_options(type, attribute_options)

      visibility = determine_visibility(attribute_options)

      reader_class = Reader
      writer_class = attribute_options[:coerce] ? Writer::Coercible : Writer

      reader   = reader_class.new(name, visibility[:reader])
      writer   = writer_class.new(name, visibility[:writer], writer_options(attribute_options))
      accessor = Accessor.new(reader, writer)

      attribute_class.new(name, accessor)
    end

    # Return options accepted by Writer
    #
    # @return [Array<Symbol>]
    #
    # @api private
    def self.writer_options(attribute_options)
      [ :coercer, :coercion_method, :primitive ].each_with_object({}) { |key, options|
        options[key] = attribute_options[key]
      }
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
      type = case class_or_name
      when ::Class
        Attribute::EmbeddedValue.determine_type(class_or_name) || super
      when ::String
        super
      when ::Enumerable
        super(class_or_name.class)
      else
        super
      end

      type or raise(
        ArgumentError, "#{class_or_name.inspect} does not map to an attribute type"
      )
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
      { :coerce => coerce }.update(options).update(determine_visibility(options))
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
      @name     = name.to_sym
      @accessor = accessor
    end

    # @api public
    def coerce?
      @coerce
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

    # Creates an attribute reader method
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_reader_method(mod)
      reader = accessor.reader
      mod.define_reader_method(accessor, reader.name, reader.visibility)
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
      mod.define_writer_method(accessor, writer.name, writer.visibility)
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
