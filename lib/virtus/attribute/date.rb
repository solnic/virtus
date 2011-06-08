module Virtus
  class Attribute
    class Date < Object
      primitive ::Date

      # Typecasts an arbitrary value to a Date
      # Handles both Hashes and Date instances.
      #
      # @param [Hash, #to_mash, #to_s] value
      #   value to be typecast
      #
      # @return [Date]
      #   Date constructed from value
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Time.to_date(value)
      end
    end # Date
  end # Attributes
end # Virtus
