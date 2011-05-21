module Virtus
  module Attributes
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
      def typecast(value, model = nil)
        if value.kind_of?(::Integer)
          value.to_s.to_d
        else
          typecast_to_numeric(value, :to_d)
        end
      end
    end # Decimal
  end # Attributes
end # Virtus
