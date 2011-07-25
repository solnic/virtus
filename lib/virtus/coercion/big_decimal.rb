module Virtus
  class Coercion

    # Coerce BigDecimal values
    class BigDecimal < Object

      FLOAT_FORMAT = 'F'.freeze

      # @api private
      def self.primitive
        ::BigDecimal
      end

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::BigDecimal.to_string(BigDecimal('1.0'))  # => "1.0"
      #
      # @param [BigDecimal] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s(FLOAT_FORMAT)
      end

      # Creates a Fixnum instance from a BigDecimal
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

      # Creates a Float instance from a BigDecimal
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

    end # class BigDecimal
  end # class Coercion
end # module Virtus
