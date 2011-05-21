module Virtus
  module Attributes
    class Integer < Numeric
      primitive ::Integer

      # Typecast a value to an Integer
      #
      # @param [#to_str, #to_i] value
      #   value to typecast
      #
      # @return [Integer]
      #   Integer constructed from value
      #
      # @api private
      def typecast(value, model = nil)
        typecast_to_numeric(value, :to_i)
      end
    end # Integer
  end # Attributes
end # Virtus
