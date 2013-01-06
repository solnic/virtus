module Virtus
  class Attribute
    class Writer < AccessorMethod

      class Coercible < self

        attr_reader :coercer

        attr_reader :coercion_method

        # @api private
        def initialize(name, options = {})
          super
          @coercer         = options[:coercer] || Virtus.coercer
          @coercion_method = options[:coercion_method]
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
          coercer[value.class].public_send(coercion_method, value)
        end

      end # class Coercible

    end # class Writer
  end # class Attribute
end # module Virtus
