module Virtus
  class Attribute
    class DateTime < Object
      primitive ::DateTime

      # Typecasts an arbitrary value to a DateTime.
      # Handles both Hashes and DateTime instances.
      #
      # @param [Hash, #to_mash, #to_s] value
      #   value to be typecast
      #
      # @return [DateTime]
      #   DateTime constructed from value
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Time.to_datetime(value)
      end
    end # DateTime
  end # Attributes
end # Virtus
