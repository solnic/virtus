module Virtus
  class Attribute

    # Decimal
    #
    # @example
    #   class ExchangeRate
    #     include Virtus
    #
    #     attribute :dollar, Decimal
    #   end
    #
    #   ExchangeRate.new(:dollar => '2.6948')
    #
    class Decimal < Numeric
      primitive ::BigDecimal

      # @see Virtus::Typecast::Numeric.to_d
      #
      # @return [BigDecimal]
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Numeric.to_d(value)
      end

    end # class Decimal
  end # class Attribute
end # module Virtus
