module Virtus

  class Attribute
    extend DescendantsTracker, Options, TypeLookup

    include ::Equalizer.new(:type, :options)

    accept_options :primitive, :accessor, :default, :lazy, :strict, :required

    strict false
    required true
    accessor :public

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

    attr_reader :type, :primitive, :options, :default_value, :coercer

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
    def self.build(type, options = {})
      Builder.call(type, options)
    end

    # @api private
    def self.build_coercer(type, options = {})
      Coercer.new(
        options.fetch(:configured_coercer) { Virtus.coercer },
        type.coercion_method
      )
    end

    # @api private
    def self.new(*args)
      attribute = super
      yield(attribute)
      attribute.finalize
    end

    # @api private
    def self.build_type(definition)
      Axiom::Types.infer(definition.primitive)
    end

    # @api private
    def self.merge_options!(*)
      # noop
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
    def initialize(type, options)
      @type          = type
      @primitive     = type.primitive
      @options       = options
      @default_value = options.fetch(:default_value)
      @coercer       = options.fetch(:coercer)
    end

    # @api public
    def coerce(value)
      coercer.call(value)
    end

    # @api public
    def rename(name)
      self.class.build(type, options.merge(:name => name))
    end

    # @api public
    def value_coerced?(value)
      coercer.success?(primitive, value)
    end

    # Return if the attribute is coercible
    #
    # @return [Boolean]
    #
    # @api public
    def coercible?
      kind_of?(Coercible)
    end

    # @api public
    def lazy?
      kind_of?(LazyDefault)
    end

    # @api public
    def strict?
      kind_of?(Strict)
    end

    # @api public
    def required?
      options[:required]
    end

    # @api private
    def define_accessor_methods(attribute_set)
      attribute_set.define_reader_method(self, name,       options[:reader])
      attribute_set.define_writer_method(self, "#{name}=", options[:writer])
    end

    # @api private
    def finalize
      freeze
    end

  end # class Attribute

end # module Virtus
