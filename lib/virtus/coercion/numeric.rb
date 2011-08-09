module Virtus
  class Coercion

    # Base class for all numeric Coercion classes
    class Numeric < Object
      primitive ::Numeric

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::Float.to_string(1.0)  # => "1.0"
      #
      # @param [Float] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # Creates a Fixnum instance from a numeric object
      #
      # @example
      #   Virtus::Coercion::BigDecimal.to_integer(BigDecimal('1.0'))  # => 1
      #
      # @param [BigDecimal] value
      #
      # @return [Fixnum]
      #
      # @api public
      def self.to_integer(value)
        value.to_i
      end

      # Creates a Float instance from a numeric object
      #
      # @example
      #   Virtus::Coercion::BigDecimal.to_float(BigDecimal('1.0'))  # => 1.0
      #
      # @param [BigDecimal] value
      #
      # @return [Fixnum]
      #
      # @api public
      def self.to_float(value)
        value.to_f
      end

      # Coerce given value to BigDecimal
      #
      # @example
      #   Virtus::Coercion::Float.to_decimal(1.0)  # => BigDecimal('1.0')
      #
      # @param [Float] value
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
