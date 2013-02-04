module Virtus
  class Attribute
    class Writer < AccessorMethod

      class Coercible < self

        # Return coercer object used by this writer
        #
        # @return [Object]
        #
        # @api private
        attr_reader :coercer

        # @api private
        def initialize(name, options = {})
          super
          @coercer = options.fetch(:coercer)
        end

        # @api private
        def call(instance, value)
          super(instance, coerce(value))
        end

        # Converts the given value to the primitive type
        #
        # @example
        #   attribute.coerce(value)  # => primitive_value
        #
        # @param [Object] value
        #   the value
        #
        # @return [Object]
        #   nil, original value or value converted to the primitive type
        #
        # @api public
        def coerce(value)
          coercer.call(value)
        end

      end # class Coercible

    end # class Writer
  end # class Attribute
end # module Virtus
