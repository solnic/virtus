module Character
  module Attributes
    class Time < Object
      include Typecast::Time

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
      def typecast(value, model = nil)
        if value.respond_to?(:to_time)
          value.to_time
        elsif value.is_a?(::Hash)
          typecast_hash_to_time(value)
        else
          ::Time.parse(value.to_s)
        end
      rescue ArgumentError
        value
      end

      # Creates a Time instance from a Hash with keys :year, :month, :day,
      # :hour, :min, :sec
      #
      # @param [Hash, #to_mash] value
      #   value to be typecast
      #
      # @return [Time]
      #   Time constructed from hash
      #
      # @api private
      def typecast_hash_to_time(value)
        ::Time.local(*extract_time(value))
      end
    end # Time
  end # Attributes
end # Character
