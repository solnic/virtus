module Virtus
  class Attribute
    class EmbeddedValue < Object

      # EmbeddedValue attribute handling OpenStruct primitive or Virtus object
      #
      class FromOpenStruct < EmbeddedValue

        # @api private
        def coerce(attributes)
          unless attributes.nil?
            super or @primitive.new(attributes)
          end
        end

      end # class FromOpenStruct
    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
