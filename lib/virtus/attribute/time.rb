module Virtus
  class Attribute
    class Time < Object
      primitive ::Time

      # Typecasts an arbitrary value to a Time
      # Handles both Hashes and Time instances.
      #
      # @param [Hash, #to_mash, #to_s] value
      #   value to be typecast
      #
      # @return [Time]
      #   Time constructed from value
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Time.to_time(value)
      end
    end # Time
  end # Attributes
end # Virtus
