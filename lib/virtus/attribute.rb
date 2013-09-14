module Virtus

  class Attribute
    extend DescendantsTracker, Options

    include Equalizer.new(inspect) << :name

    accept_options :primitive, :accessor, :reader, :writer, :default, :lazy

    accessor :public

    module Named
      # @api public
      def name
        options[:name]
      end

      # @api public
      def get(instance)
        instance.instance_variable_get(instance_variable_name)
      end

      # @api public
      def set(instance, value)
        instance.instance_variable_set(instance_variable_name, value)
      end

      # @api public
      def set_default_value(instance)
        default_value.call(instance, self)
      end

      def define_accessor_methods(attribute_set)
        attribute_set.define_reader_method(self, name,       options[:reader])
        attribute_set.define_writer_method(self, "#{name}=", options[:writer])
        self
      end

      # Returns a Boolean indicating whether the reader method is public
      #
      # @return [Boolean]
      #
      # @api private
      def public_reader?
        options[:reader] == :public
      end

      # Returns a Boolean indicating whether the writer method is public
      #
      # @return [Boolean]
      #
      # @api private
      def public_writer?
        options[:writer] == :public
      end

      private

      def instance_variable_name
        "@#{name}"
      end
    end

    module Coercible
      def set(instance, value)
        super(instance, coercer.call(value))
      end

      def coercer
        options[:coercer]
      end

      def value_coerced?(value)
        coercer.coerced?(value)
      end
    end

    module LazyDefault
      def get(instance)
        if instance.instance_variable_defined?(instance_variable_name)
          super
        else
          set_default_value(instance)
        end
      end
    end

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

    attr_reader :type, :options, :default_value

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
      Builder.new(type, options).attribute
    end

    # @api private
    def self.build_type(type, _options)
      Axiom::Types.infer(type).new
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
      @options       = options
      @default_value = options.fetch(:default_value)
    end

    # Return if the attribute is coercible
    #
    # @return [Boolean]
    #
    # @api public
    def coercible?
      kind_of?(Coercible)
    end

    def lazy?
      kind_of?(LazyDefault)
    end

  end # class Attribute

end # module Virtus
