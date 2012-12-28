module Virtus
  class Attribute

    class Accessor
      attr_reader :reader

      attr_reader :writer

      # @api private
      def initialize(reader, writer)
        @reader, @writer = reader, writer
      end

      # @api public
      def set(*args)
        writer.set(*args)
      end

      # @api public
      def get(*args)
        reader.get(*args)
      end
    end

  end # class Attribute
end # module Virtus
