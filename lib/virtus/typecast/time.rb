module Virtus
  module Typecast

    # Time
    #
    class Time < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::Time.to_string(time)  # => "Wed Jul 20 10:30:41 -0700 2011"
      #
      # @param [Time] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # Typecast given value to DateTime
      #
      # @example
      #   Virtus::Typecast::Time.to_datetime(time)  # => DateTime object
      #
      # @param [Time] value
      #
      # @return [DateTime]
      #
      # @api public
      def self.to_datetime(value)
        if value.respond_to?(:to_datetime)
          value.to_datetime
        else
          String.to_datetime(to_string(value))
        end
      end

      # Typecast given value to Date
      #
      # @example
      #   Virtus::Typecast::Time.to_date(date)  # => Date object
      #
      # @param [Time] value
      #
      # @return [Date]
      #
      # @api public
      def self.to_date(value)
        if value.respond_to?(:to_date)
          value.to_date
        else
          String.to_date(to_string(value))
        end
      end

    end # class Time
  end # module Typecast
end # module Virtus
