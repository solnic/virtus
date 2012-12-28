module Virtus
  class Attribute
    class Writer

      class Coercible < self

        attr_reader :coercer

        attr_reader :coercion_method

        # @api private
        def initialize(name, visibility, options = {})
          super
          @coercer         = options.fetch(:coercer)
          @coercion_method = options.fetch(:coercion_method)
        end

        # @api public
        def set(instance, value)
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
          coercer[value.class].public_send(coercion_method, value)
        end

      end # class Coercible

    end # class Writer
  end # class Attribute
end # module Virtus
