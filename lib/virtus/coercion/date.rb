module Virtus
  class Coercion

    # Coerce Date values
    class Date < Object

      # @api private
      def self.primitive
        ::Date
      end

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::Date.to_string(date)  # => "2011-07-20"
      #
      # @param [Date] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # Coerce given value to DateTime
      #
      # @example
      #   Virtus::Coercion::Date.to_datetime(date)  # => DateTime object
      #
      # @param [Date] value
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

      # Coerce given value to Time
      #
      # @example
      #   Virtus::Coercion::Date.to_time(date)  # => Time object
      #
      # @param [Date] value
      #
      # @return [Time]
      #
      # @api public
      def self.to_time(value)
        if value.respond_to?(:to_time)
          value.to_time
        else
          String.to_time(to_string(value))
        end
      end

    end # class Date
  end # class Coercion
end # module Virtus
