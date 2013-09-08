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

      def initialize(type, options)
        @klass   = Attribute
        @type    = Axiom::Types.infer(type).new
        @options = merge_options(options)

        determine_visibility!

        @attribute = Attribute.new(@type, @options)

        @attribute.extend(Attribute::Named)       if @options[:name]
        @attribute.extend(Attribute::Coercible)   if @options[:coercer]
        @attribute.extend(Attribute::LazyDefault) if @options[:lazy]
      end

      def merge_options(options)
        merged_options = @klass.options.merge(
          :coerce => Virtus.coerce, :primitive => @type.primitive
        ).update(options)

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
