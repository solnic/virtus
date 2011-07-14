module Virtus
  module Typecast

    # BigDecimal
    #
    class BigDecimal < Base

      # @api public
      def self.to_i(value)
        value.to_i
      end

      # @api public
      def self.to_f(value)
        value.to_f
      end

    end # class Integer
  end # module Typecast
end # module Virtus
