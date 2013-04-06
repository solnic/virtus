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

      def initialize(name, type, options)
        @type    = Axiom::Types.infer(type)
        @options = merge_options(options)

        @accessor  = Accessor.build(name, self, @options)
        @attribute = Attribute.new(name, accessor)
      end

      def merge_options(options)
        merged_options = @type.options.merge(options)

        if merged_options[:coerce]
          merged_options.update(
            :coercer => merged_options.fetch(:coercer) { coercer(options) }
          )
        end

        merged_options
      end

      def writer_options
        ::Hash[writer_option_names.zip(@options.values_at(*writer_option_names))]
      end

      def writer_option_names
        [ :coercer, :primitive, :default ]
      end

      def reader_class
        Reader
      end

      def writer_class
        @options[:coerce] ? coercible_writer_class : Writer
      end

      def coercible_writer_class
        Writer::Coercible
      end

      def coercer(*)
        Coercer.new(Virtus.coercer, @type.coercion_method)
      end

    end # class Builder

  end # class Attribute
end # module Virtus
