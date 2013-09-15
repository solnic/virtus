module Virtus
  class Attribute

    class Builder
      attr_reader :attribute

      def self.call(*args)
        new(*args).attribute
      end

      def self.handles?(type)
        false
      end

      def self.determine_type(primitive)
        if primitive == Array || primitive == Set
          Collection
        else
          Attribute.descendants.detect { |descendant| descendant.primitive == primitive } || Attribute
        end
      end

      def initialize(type, options)
        @primitive =
          if type.instance_of?(::Hash) || type == Hash
            ::Hash
          elsif type.instance_of?(::Array) || type == Array
            ::Array
          elsif type.instance_of?(::Set) || type == Set
            ::Set
          else
            type
          end

        @klass = self.class.determine_type(@primitive)
        @type  = @klass.build_type(type, options)

        @options = merge_options(options)

        @klass.merge_options!(@type, @options)

        determine_visibility!

        @attribute = @klass.new(@type, @options)

        @attribute.extend(Attribute::Named)       if @options[:name]
        @attribute.extend(Attribute::Coercible)   if @options[:coercer]
        @attribute.extend(Attribute::LazyDefault) if @options[:lazy]
      end

      def merge_options(options)
        merged_options = @klass.options.merge(:coerce => Virtus.coerce).update(options)

        merged_options.update(:default_value => DefaultValue.build(options[:default]))

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

      def coercer(*)
        Coercer.new(Virtus.coercer, @type.coercion_method)
      end

    end # class Builder

  end # class Attribute
end # module Virtus
