module Virtus

  # @private
  class PendingAttribute
    attr_reader :name

    # @api private
    def initialize(type, options)
      @type    = type
      @options = options
      @name    = options[:name]
    end

    # @api private
    def finalize
      Attribute::Builder.call(determine_type, @options)
    end

    # @api private
    def determine_type
      if @type.include?('::')
        raise NotImplementedError
      else
        Object.const_get(@type)
      end
    end

  end # PendingAttribute

  class TypeDefinition
    attr_reader :type, :primitive

    # @api private
    def initialize(type)
      @type = type
      initialize_primitive
    end

    # @api private
    def pending?
      @pending
    end

    private

    # @api private
    def initialize_primitive
      @primitive =
        if type.instance_of?(String) || type.instance_of?(Symbol)
          if Object.const_defined?(type)
            Object.const_get(type)
          elsif not Attribute::Builder.determine_type(type)
            @pending = true
            type
          else
            type
          end
        elsif not type.is_a?(Class)
          type.class
        else
          type
        end
    end
  end

  class Attribute

    # TODO: this is a huge class and it might be a good idea to split it into
    #       smaller chunks. We probably need some option parser with dedicated
    #       sub-classes per attribute type (different one for Hash, Collection, EV)
    #
    # @private
    class Builder
      attr_reader :attribute

      # @api private
      def self.call(type, options = {})
        type_definition = TypeDefinition.new(type)

        if type_definition.pending?
          PendingAttribute.new(type, options)
        else
          new(type_definition, options).attribute
        end
      end

      # @api private
      def self.determine_type(klass, default = nil)
        type = Attribute.determine_type(klass)

        if klass.is_a?(Class)
          type ||=
            if klass < Axiom::Types::Type
              determine_type(klass.primitive)
            elsif EmbeddedValue.handles?(klass)
              EmbeddedValue
            elsif klass < Enumerable
              Collection
            end
        end

        type || default
      end

      # @api private
      def initialize(type_definition, options)
        @type_definition = type_definition

        initialize_class
        initialize_type
        initialize_options(options)
        initialize_default_value
        initialize_coercer
        initialize_attribute
      end

      private

      # @api private
      def initialize_class
        @klass = self.class.determine_type(@type_definition.primitive, Attribute)
      end

      # @api private
      def initialize_type
        @type = @klass.build_type(@type_definition)
      end

      # @api private
      def initialize_options(options)
        @options = @klass.options.merge(:coerce => Virtus.coerce).update(options)
        @klass.merge_options!(@type, @options)
        determine_visibility!
      end

      # @api private
      def determine_visibility!
        default_accessor  = @options.fetch(:accessor)
        reader_visibility = @options.fetch(:reader, default_accessor)
        writer_visibility = @options.fetch(:writer, default_accessor)
        @options.update(:reader => reader_visibility, :writer => writer_visibility)
      end

      # @api private
      def initialize_default_value
        @options.update(:default_value => DefaultValue.build(@options[:default]))
      end

      # @api private
      def initialize_coercer
        @options.update(:coercer => @options.fetch(:coercer) { @klass.build_coercer(@type, @options) })
      end

      # @api private
      def initialize_attribute
        @attribute = @klass.new(@type, @options) do |attribute|
          attribute.extend(Accessor)    if @options[:name]
          attribute.extend(Coercible)   if @options[:coerce]
          attribute.extend(Strict)      if @options[:strict]
          attribute.extend(LazyDefault) if @options[:lazy]
        end
      end

    end # class Builder

  end # class Attribute
end # module Virtus
