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
      def self.build(*args)
        Builder.call(*args)
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
      # @api private
      def get(instance)
        reader.call(instance)
      end

      # Set a variable on an object
      #
      # @return [Object]
      #
      # @api private
      def set(*args)
        writer.call(*args)
      end

      # Return if reader method is public
      #
      # @return [Boolean]
      #
      # @api private
      def public_reader?
        reader.public?
      end

      # Return if writer method is public
      #
      # @return [Boolean]
      #
      # @api private
      def public_writer?
        writer.public?
      end

      # Return if this accessor is lazy
      #
      # @return [FalseClass]
      #
      # @api private
      def lazy?
        false
      end

    end # class Accessor

  end # class Attribute
end # module Virtus
