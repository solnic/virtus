module Virtus
  class Attribute

    # Example usage:
    #
    #   class ExchangeRate
    #     include Virtus
    #
    #     attribute :dollar, Float
    #   end
    #
    #   ExchangeRate.new(:dollar => 2.69)
    #
    #   # typecasting from a string
    #   ExchangeRate.new(:dollar => '2.69')
    #
    #   # typecasting from an integer
    #   ExchangeRate.new(:dollar => 2)
    #
    #   # typecasting from an object which implements #to_f
    #   ExchangeRate.new(:dollar => BigDecimal.new('2.69')
    #
    class Float < Numeric
      primitive ::Float

      # @see Virtus::Typecast::Numeric.to_f
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Numeric.to_f(value)
      end

    end # class Float
  end # class Attributes
end # module Virtus
