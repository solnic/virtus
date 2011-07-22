module Virtus
  module Typecast

    # BigDecimal
    #
    class BigDecimal < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::BigDecimal.to_string(BigDecimal('1.0')) # => "1.0"
      #
      # @param [BigDecimal] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s('F')
      end

      # Creates a Fixnum instance from a BigDecimal
      #
      # @example
      #   Virtus::Typecast::BigDecimal.to_integer(BigDecimal('1.0')) # => 1
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
      #   Virtus::Typecast::BigDecimal.to_f(BigDecimal('1.0')) # => 1.0
      #
      # @param [BigDecimal] value
      #
      # @return [Fixnum]
      #
      # @api public
      def self.to_f(value)
        value.to_f
      end

    end # class BigDecimal
  end # module Typecast
end # module Virtus
