module Virtus
  class Attribute
    class EmbeddedValue < Object

      # EmbeddedValue coercer handling OpenStruct primitive or Virtus object
      #
      class OpenStructCoercer

        # Return primitive class
        #
        # @return [::Class]
        #
        # @api private
        attr_reader :primitive

        # Initialize coercer object
        #
        # @return [undefined]
        #
        # @api private
        def initialize(primitive)
          @primitive = primitive
        end

        # Build object from attribute hash
        #
        # @return [::Object]
        #
        # @api private
        def call(attributes)
          if attributes.kind_of?(primitive)
            attributes
          elsif not attributes.nil?
            primitive.new(attributes)
          end
        end

      end # class OpenStructCoercer
    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
