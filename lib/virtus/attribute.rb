module Virtus

  # Attribute objects handle coercion and provide interface to hook into an
  # attribute set instance that's included into a class or object
  #
  # @example
  #
  #   # non-strict mode
  #   attr = Virtus::Attribute.build(Integer)
  #   attr.coerce('1')
  #   # => 1
  #
  #   # strict mode
  #   attr = Virtus::Attribute.build(Integer, :strict => true)
  #   attr.coerce('not really coercible')
  #   # => Virtus::CoercionError: Failed to coerce "fsafa" into Integer
  #
  class Attribute
    extend DescendantsTracker, Options, TypeLookup

    include ::Equalizer.new(:type, :options)

    accept_options :primitive, :accessor, :default, :lazy, :strict, :required, :finalize

    strict false
    required true
    accessor :public
    finalize true

    # @see Virtus.coerce
    #
    # @deprecated
    #
    # @api public
    def self.coerce(value = Undefined)
      Virtus.warn "#{self}.coerce is deprecated and will be removed in 1.0.0. Use Virtus.coerce instead: ##{caller.first}"
      return Virtus.coerce if value.equal?(Undefined)
      Virtus.coerce = value
      self
    end

    # Return type of this attribute
    #
    # @return [Axiom::Types::Type]
    #
    # @api public
    attr_reader :type

    # @api private
    attr_reader :primitive, :options, :default_value, :coercer

    # Builds an attribute instance
    #
    # @param [Class,Array,Hash,String,Symbol] type
    #   this can be an explicit class or an object from which virtus can infer
    #   the type
    #
    # @param [#to_hash] options
    #   optional extra options hash
    #
    # @return [Attribute]
    #
    # @api public
    def self.build(type, options = {})
      Builder.call(type, options)
    end

    # @api private
    def self.build_coercer(type, options = {})
      Coercer.new(type, options.fetch(:configured_coercer) { Virtus.coercer })
    end

    # @api private
    def self.build_type(definition)
      Axiom::Types.infer(definition.primitive)
    end

    # @api private
    def self.merge_options!(*)
      # noop
    end

    # @api private
    def initialize(type, options)
      @type          = type
      @primitive     = type.primitive
      @options       = options
      @default_value = options.fetch(:default_value)
      @coercer       = options.fetch(:coercer)
    end

    # Coerce the input into the expected type
    #
    # @example
    #
    #   attr = Virtus::Attribute.build(String)
    #   attr.coerce(:one) # => 'one'
    #
    # @param [Object] input
    #
    # @api public
    def coerce(input)
      coercer.call(input)
    end

    # Return a new attribute with the new name
    #
    # @param [Symbol] name
    #
    # @return [Attribute]
    #
    # @api public
    def rename(name)
      self.class.build(type, options.merge(:name => name))
    end

    # Return if the given value was coerced
    #
    # @param [Object] value
    #
    # @return [Boolean]
    #
    # @api public
    def value_coerced?(value)
      coercer.success?(primitive, value)
    end

    # Return if the attribute is coercible
    #
    # @example
    #
    #   attr = Virtus::Attribute.build(String, :coerce => true)
    #   attr.coercible? # => true
    #
    #   attr = Virtus::Attribute.build(String, :coerce => false)
    #   attr.coercible? # => false
    #
    # @return [Boolean]
    #
    # @api public
    def coercible?
      kind_of?(Coercible)
    end

    # Return if the attribute has lazy default value evaluation
    #
    # @example
    #
    #   attr = Virtus::Attribute.build(String, :lazy => true)
    #   attr.lazy? # => true
    #
    #   attr = Virtus::Attribute.build(String, :lazy => false)
    #   attr.lazy? # => false
    #
    # @return [Boolean]
    #
    # @api public
    def lazy?
      kind_of?(LazyDefault)
    end

    # Return if the attribute is in the strict coercion mode
    #
    # @example
    #
    #   attr = Virtus::Attribute.build(String, :strict => true)
    #   attr.strict? # => true
    #
    #   attr = Virtus::Attribute.build(String, :strict => false)
    #   attr.strict? # => false
    #
    # @return [Boolean]
    #
    # @api public
    def strict?
      kind_of?(Strict)
    end

    # Return if the attribute is accepts nil values as valid coercion output
    #
    # @example
    #
    #   attr = Virtus::Attribute.build(String, :required => true)
    #   attr.required? # => true
    #
    #   attr = Virtus::Attribute.build(String, :required => false)
    #   attr.required? # => false
    #
    # @return [Boolean]
    #
    # @api public
    def required?
      options[:required]
    end

    # Return if the attribute was already finalized
    #
    # @example
    #
    #   attr = Virtus::Attribute.build(String, :finalize => true)
    #   attr.finalized? # => true
    #
    #   attr = Virtus::Attribute.build(String, :finalize => false)
    #   attr.finalized? # => false
    #
    # @return [Boolean]
    #
    # @api public
    def finalized?
      frozen?
    end

    # @api private
    def define_accessor_methods(attribute_set)
      attribute_set.define_reader_method(self, name,       options[:reader])
      attribute_set.define_writer_method(self, "#{name}=", options[:writer])
    end

    # @api private
    def finalize
      freeze
      self
    end

  end # class Attribute

end # module Virtus
