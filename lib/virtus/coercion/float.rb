module Virtus
  class Coercion

    # Coerce Float values
    class Float < Object

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

      # Coerce given value to Integer
      #
      # @example
      #   Virtus::Coercion::Float.to_integer(1.0)  # => 1
      #
      # @param [Float] value
      #
      # @return [Integer]
      #
      # @api public
      def self.to_integer(value)
        value.to_i
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

    end # class Float
  end # class Coercion
end # module Virtus
