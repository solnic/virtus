module Virtus
  class Attribute
    class Float < Numeric
      primitive ::Float

      # Typecast a value to a Float
      #
      # @param [#to_str, #to_f] value
      #   value to typecast
      #
      # @return [Float]
      #   Float constructed from value
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Numeric.to_f(value)
      end
    end # Float
  end # Attributes
end # Virtus
