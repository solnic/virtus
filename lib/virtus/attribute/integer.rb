module Virtus
  class Attribute
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
      def typecast_to_primitive(value)
        Typecast::Numeric.to_i(value)
      end
    end # Integer
  end # Attributes
end # Virtus
