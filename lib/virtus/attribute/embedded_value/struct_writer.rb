module Virtus
  class Attribute
    class EmbeddedValue < Object

      # EmbeddedValue attribute handling Struct primitive
      #
      class StructWriter < Attribute::Writer::Coercible

        # @api private
        def coerce(attributes)
          if attributes.kind_of?(primitive)
            attributes
          elsif not attributes.nil?
            primitive.new(*attributes)
          end
        end

      end # class FromStruct
    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
