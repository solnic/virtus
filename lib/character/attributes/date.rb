module Character
  module Attributes
    class Date < Object
      include Typecast::Time

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
      def typecast(value, model = nil)
        if value.respond_to?(:to_date)
          value.to_date
        elsif value.is_a?(::Hash)
          typecast_hash_to_date(value)
        else
          ::Date.parse(value.to_s)
        end
      rescue ArgumentError
        value
      end

      # Creates a Date instance from a Hash with keys :year, :month, :day
      #
      # @param [Hash, #to_mash] value
      #   value to be typecast
      #
      # @return [Date]
      #   Date constructed from hash
      #
      # @api private
      def typecast_hash_to_date(value)
        ::Date.new(*extract_time(value)[0, 3])
      end
    end # Date
  end # Attributes
end # Character
