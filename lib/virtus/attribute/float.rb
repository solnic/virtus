module Virtus
  class Attribute

    # Float
    #
    # @example
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
      # @return [Float]
      #
      # @api private
      def typecast(value)
        Typecast::Numeric.to_f(value)
      end

    end # class Float
  end # class Attribute
end # module Virtus
