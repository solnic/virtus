module Virtus

  # Abstract class implementing base API for attribute types
  #
  # @abstract
  class Attribute
    extend DescendantsTracker, TypeLookup, Options

    include Adamantium::Flat
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

    # Return accessor object
    #
    # @return [Accessor]
    #
    # @api private
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
      klass = determine_type(type) or raise(
        ArgumentError, "#{type.inspect} does not map to an attribute type"
      )

      attribute_options = klass.merge_options(type, options)
      accessor          = Accessor.build(name, klass, attribute_options)

      klass.new(name, accessor)
    end

    # @api public
    def self.coercer(*args)
      Coercer.new(Virtus.coercer, coercion_method)
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

    # @api private
    def self.reader_options(attribute_options)
      {}
    end

    # Return options accepted by Writer
    #
    # @return [Array<Symbol>]
    #
    # @api private
    def self.writer_options(attribute_options)
      ::Hash[writer_option_names.zip(attribute_options.values_at(*writer_option_names))]
    end

    # @api private
    def self.writer_option_names
      [ :coercer, :primitive, :default ]
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
    def self.merge_options(type, options)
      merged_options = self.options.merge(options)

      if merged_options[:coerce]
        merged_options.update(
          :coercer => merged_options.fetch(:coercer) { coercer(type, options) }
        )
      end

      merged_options
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
    def reader
      accessor.reader
    end

    # @api public
    def writer
      accessor.writer
    end

    # Is the given value coerced into the target type for this attribute?
    #
    # @return [Boolean]
    #
    # @api private
    def value_coerced?(value)
      coercer.coerced?(value)
    end

    # Define reader and writer methods for an Attribute
    #
    # @param [Module] mod
    #
    # @return [self]
    #
    # @api private
    def define_accessor_methods(mod)
      reader.define_method(accessor, mod)
      writer.define_method(accessor, mod)
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

    private

    # Return coercer for this attribute
    #
    # @return [Object]
    #
    # @api private
    def coercer
      writer.coercer[self.class.primitive]
    end

  end # class Attribute

end # module Virtus
