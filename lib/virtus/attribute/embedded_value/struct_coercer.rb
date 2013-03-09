module Virtus
  class Attribute
    class EmbeddedValue < Object

      # EmbeddedValue coercer handling Struct primitive
      #
      class StructCoercer
        # Return primitive class
        #
        # @return [::Class]
        #
        # @api private
        attr_reader :primitive

        # Initialize coercer instance
        #
        # @return [undefined]
        #
        # @api private
        def initialize(primitive)
          @primitive = primitive
        end

        # Build a struct object from attributes
        #
        # @return [Struct]
        #
        # @api private
        def call(attributes)
          if attributes.kind_of?(primitive)
            attributes
          elsif not attributes.nil?
            primitive.new(*attributes)
          end
        end

      end # class StructCoercer
    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
