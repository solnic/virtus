module Virtus
  class Attribute

    # Accessor object providing reader and writer methods
    #
    # @api private
    class Accessor
      include Adamantium::Flat

      # Return reader
      #
      # @return [Reader]
      #
      # @api private
      attr_reader :reader

      # Return writer
      #
      # @return [Writer]
      #
      # @api private
      attr_reader :writer

      # Build an accessor instance
      #
      # @param [Symbol] name
      #
      # @param [Class] type
      #
      # @param [Hash] options
      #
      # @return [Accessor]
      #
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

        klass = options[:lazy] ? Accessor::LazyAccessor : self
        klass.new(reader, writer)
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

      # Initialize a new accessor instance
      #
      # @param [Reader]
      #
      # @param [Writer]
      #
      # @return [undefined]
      #
      # @api private
      def initialize(reader, writer)
        @reader, @writer = reader, writer
      end

      # Get a variable value from an object
      #
      # @return [Object]
      #
      # @api public
      def get(instance)
        reader.call(instance)
      end

      # Set a variable on an object
      #
      # @return [Object]
      #
      # @api public
      def set(*args)
        writer.call(*args)
      end

      # Return if reader method is public
      #
      # @return [Boolean]
      #
      # @api public
      def public_reader?
        reader.public?
      end

      # Return if writer method is public
      #
      # @return [Boolean]
      #
      # @api public
      def public_writer?
        writer.public?
      end

      # @api private
      def lazy?
        false
      end

    end # class Accessor

  end # class Attribute
end # module Virtus
