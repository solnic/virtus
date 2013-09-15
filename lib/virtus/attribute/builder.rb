module Virtus
  class Attribute

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
              Collection.determine_type(class_or_name)  ||
              Attribute.determine_type(class_or_name)
          else
            Attribute.determine_type(class_or_name)
          end

        type || Attribute
      end

      def initialize(type, options)
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

        @klass = self.class.determine_type(@primitive)
        @type  = @klass.build_type(type, options)

        @options = merge_options(options)

        @options[:primitive] = type

        @klass.merge_options!(@type, @options)

        determine_visibility!

        @attribute = @klass.new(@type, @options)

        @attribute.extend(Attribute::Named)       if @options[:name]
        @attribute.extend(Attribute::Coercible)   if @options[:coercer]
        @attribute.extend(Attribute::LazyDefault) if @options[:lazy]
      end

      def merge_options(options)
        merged_options = @klass.options.merge(:coerce => Virtus.coerce).update(options)

        merged_options.update(:default_value => DefaultValue.build(merged_options[:default]))

        if merged_options[:coerce]
          merged_options.update(
            :coercer => merged_options.fetch(:coercer) { coercer(options) }
          )
        end

        merged_options
      end

      def determine_visibility!
        default_accessor  = @options.fetch(:accessor)
        reader_visibility = @options.fetch(:reader, default_accessor)
        writer_visibility = @options.fetch(:writer, default_accessor)
        @options.update(:reader => reader_visibility, :writer => writer_visibility)
      end

      def coercer(options)
        Coercer.new(
          options.fetch(:configured_coercer) { Virtus.coercer },
          @type.coercion_method
        )
      end

    end # class Builder

  end # class Attribute
end # module Virtus
