module Virtus
  module Attributes
    class DateTime < Object
      primitive ::DateTime

      include Typecast::Time

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
      def typecast(value, model = nil)
        if value.is_a?(::Hash)
          typecast_hash_to_datetime(value)
        else
          ::DateTime.parse(value.to_s)
        end
      rescue ArgumentError
        value
      end

      # Creates a DateTime instance from a Hash with keys :year, :month, :day,
      # :hour, :min, :sec
      #
      # @param [Hash, #to_mash] value
      #   value to be typecast
      #
      # @return [DateTime]
      #   DateTime constructed from hash
      #
      # @api private
      def typecast_hash_to_datetime(value)
        ::DateTime.new(*extract_time(value))
      end
    end # DateTime
  end # Attributes
end # Virtus
