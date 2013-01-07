module Virtus
  class Attribute

    class Accessor
      attr_reader :reader

      attr_reader :writer

      # @api private
      def self.build(name, type, options)
        primitive  = options[:primitive]
        visibility = determine_visibility(options)

        reader_class = options.fetch(:reader_class) { type.reader_class(primitive, options) }
        writer_class = options.fetch(:writer_class) { type.writer_class(primitive, options) }

        reader_options = type.reader_options(options).update(:visibility => visibility[:reader])
        writer_options = type.writer_options(options).update(:visibility => visibility[:writer])

        reader = reader_class.new(name, reader_options)
        writer = writer_class.new(name, writer_options)

        new(reader, writer)
      end

      # Determine visibility of reader/write methods based on the options hash
      #
      # @return [::Hash]
      #
      # @api private
      def self.determine_visibility(options)
        default_accessor  = options.fetch(:accessor, :public)
        reader_visibility = options.fetch(:reader, default_accessor)
        writer_visibility = options.fetch(:writer, default_accessor)

        { :reader => reader_visibility, :writer => writer_visibility }
      end
      private_class_method :determine_visibility

      # @api private
      def initialize(reader, writer)
        @reader, @writer = reader, writer
      end

      # @api public
      def get(instance)
        if instance.instance_variable_defined?(reader.instance_variable_name)
          reader.call(instance)
        else
          value = writer.default_value.call(instance, self)
          writer.call(instance, value)
          value
        end
      end

      # @api public
      def set(*args)
        writer.call(*args)
      end

      # @api public
      def public_reader?
        reader.public?
      end

      # @api public
      def public_writer?
        writer.public?
      end

    end # class Accessor

  end # class Attribute
end # module Virtus
