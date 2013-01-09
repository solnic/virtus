module Virtus
  class Attribute
    class EmbeddedValue < Object

      # EmbeddedValue attribute handling OpenStruct primitive or Virtus object
      #
      class OpenStructCoercer
        attr_reader :primitive

        def initialize(primitive)
          @primitive = primitive
        end

        # @api private
        def call(attributes)
          if attributes.kind_of?(primitive)
            attributes
          elsif not attributes.nil?
            primitive.new(attributes)
          end
        end

      end # class FromOpenStruct
    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
