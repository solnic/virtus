module Virtus
  class Coercion

    # Base class for all numeric Coercion classes
    class Numeric < Object
      primitive ::Numeric

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::Numeric.to_string(Rational(2, 2))  # => "1.0"
      #
      # @param [Numeric] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # Creates an Integer instance from a numeric object
      #
      # @example
      #   Virtus::Coercion::Numeric.to_integer(Rational(2, 2))  # => 1
      #
      # @param [Numeric] value
      #
      # @return [Integer]
      #
      # @api public
      def self.to_integer(value)
        value.to_i
      end

      # Creates a Float instance from a numeric object
      #
      # @example
      #   Virtus::Coercion::Numeric.to_float(Rational(2, 2))  # => 1.0
      #
      # @param [Numeric] value
      #
      # @return [Float]
      #
      # @api public
      def self.to_float(value)
        value.to_f
      end

      # Coerce a BigDecimal instance from a numeric object
      #
      # @example
      #   Virtus::Coercion::Numeric.to_decimal(Rational(2, 2))  # => BigDecimal('1.0')
      #
      # @param [Numeric] value
      #
      # @return [BigDecimal]
      #
      # @api public
      def self.to_decimal(value)
        to_string(value).to_d
      end

    end # class Numeric
  end # class Coercion
end # module Virtus
