module Virtus
  class Attribute

    # TODO: this is a huge class and it might be a good idea to split it into
    #       smaller chunks. We probably need some option parser with dedicated
    #       sub-classes per attribute type (different one for Hash, Collection, EV)
    #
    # @private
    class Builder
      attr_reader :attribute

      # @api private
      def self.call(*args)
        new(*args).attribute
      end

      # @api private
      def self.determine_type(class_or_name)
        if class_or_name.is_a?(Class) && class_or_name <= Attribute
          return class_or_name
        end

        type =
          case class_or_name
          when ::Class
            EmbeddedValue.determine_type(class_or_name) ||
              Attribute.determine_type(class_or_name)   ||
              Collection.determine_type(class_or_name)
          else
            Attribute.determine_type(class_or_name)
          end

        type || Attribute
      end

      # @api private
      def initialize(type, options)
        initialize_primitive(type)
        initialize_class
        initialize_type(type, options)
        initialize_options(options)
        initialize_default_value
        initialize_coercer if coerce?
        initialize_attribute
      end

      private

      # @api private
      def initialize_attribute
        @attribute = @klass.new(@type, @options)

        @attribute.extend(Attribute::Named)       if @options[:name]
        @attribute.extend(Attribute::Coercible)   if @options[:coercer]
        @attribute.extend(Attribute::LazyDefault) if @options[:lazy]
      end

      # @api private
      def initialize_default_value
        @options.update(:default_value => DefaultValue.build(@options[:default]))
      end

      # @api private
      def initialize_coercer
        @options.update(:coercer => @options.fetch(:coercer) { build_coercer })
      end

      # @api private
      def initialize_primitive(type)
        @primitive =
          if type.instance_of?(::Hash) || type == ::Hash
            ::Hash
          elsif type.instance_of?(::Array) || type == ::Array
            ::Array
          elsif type.instance_of?(::Set) || type == ::Set
            ::Set
          elsif type.kind_of?(Enumerable)
            type.class
          else
            type
          end
      end

      # @api private
      def initialize_class
        @klass = self.class.determine_type(@primitive)
      end

      # @api private
      def initialize_type(type, options)
        @type = @klass.build_type(type, options)
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
      def coerce?
        @options[:coerce]
      end

      # @api private
      def build_coercer
        Coercer.new(
          @options.fetch(:configured_coercer) { Virtus.coercer },
          @type.coercion_method
        )
      end

    end # class Builder

  end # class Attribute
end # module Virtus
