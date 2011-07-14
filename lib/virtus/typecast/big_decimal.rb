module Virtus
  module Typecast

    # BigDecimal
    #
    class BigDecimal < Object

      # @api public
      def self.to_i(value)
        value.to_i
      end

      # @api public
      def self.to_f(value)
        value.to_f
      end

    end # class BigDecimal
  end # module Typecast
end # module Virtus
