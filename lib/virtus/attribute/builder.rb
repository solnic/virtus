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
      def self.determine_type(klass)
        type =
          if klass.is_a?(Class)
            EmbeddedValue.determine_type(klass) ||
              Attribute.determine_type(klass)   ||
              Collection.determine_type(klass)

          else
            Attribute.determine_type(klass)
          end

        type || Attribute
      end

      # @api private
      def initialize(type, options)
        initialize_primitive(type)
        initialize_class
        initialize_type(:type => type, :primitive => @primitive)
        initialize_options(options)
        initialize_default_value
        initialize_coercer
        initialize_attribute
      end

      private

      # @api private
      def initialize_attribute
        @attribute = @klass.new(@type, @options) do |attribute|
          attribute.extend(Attribute::Named)       if @options[:name]
          attribute.extend(Attribute::Coercible)   if @options[:coerce]
          attribute.extend(Attribute::LazyDefault) if @options[:lazy]
        end
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
        const =
          if type.instance_of?(String) || type.instance_of?(Symbol)
            begin
              Object.const_get(type)
            rescue
              type
            end
          else
            type
          end

        @primitive =
          if const.instance_of?(::Hash) || const == ::Hash
            ::Hash
          elsif const.instance_of?(::Array) || const == ::Array
            ::Array
          elsif const.instance_of?(::Set) || const == ::Set
            ::Set
          elsif const.kind_of?(Enumerable)
            const.class
          else
            const
          end
      end

      # @api private
      def initialize_class
        @klass = self.class.determine_type(@primitive)
      end

      # @api private
      def initialize_type(options)
        @type = @klass.build_type(options)
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
      def build_coercer
        Coercer.new(
          @options.fetch(:configured_coercer) { Virtus.coercer },
          @type.coercion_method
        )
      end

    end # class Builder

  end # class Attribute
end # module Virtus
