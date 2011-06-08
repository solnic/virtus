module Virtus
  class Attribute
    class Decimal < Numeric
      primitive ::BigDecimal

      # Typecast a value to a BigDecimal
      #
      # @param [#to_str, #to_d, Integer] value
      #   value to typecast
      #
      # @return [BigDecimal]
      #   BigDecimal constructed from value
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Numeric.to_d(value)
      end
    end # Decimal
  end # Attributes
end # Virtus
