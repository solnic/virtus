module Virtus
  module Typecast

    # BigDecimal
    #
    class BigDecimal < Object

      # Creates a Fixnum instance from a BigDecimal
      #
      # @example
      #   Virtus::Typecast::BigDecimal.to_i(BigDecimal('1.0')) # => 1
      #
      # @param [BigDecimal] value
      #
      # @return [Fixnum]
      #
      # @api public
      def self.to_i(value)
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
