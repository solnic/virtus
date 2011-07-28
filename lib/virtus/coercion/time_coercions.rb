module Virtus
  class Coercion

    module TimeCoercions

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::Time.to_string(time)  # => "Wed Jul 20 10:30:41 -0700 2011"
      #
      # @param [Time] value
      #
      # @return [String]
      #
      # @api public
      def to_string(value)
        value.to_s
      end

      # Coerce given value to Time
      #
      # @example
      #   Virtus::Coercion::DateTime.to_time(date)  # => Time object
      #
      # @param [DateTime] value
      #
      # @return [Time]
      #
      # @api public
      def to_time(value)
        if value.respond_to?(:to_time)
          value.to_time
        else
          String.to_time(to_string(value))
        end
      end

      # Coerce given value to DateTime
      #
      # @example
      #   Virtus::Coercion::Time.to_datetime(time)  # => DateTime object
      #
      # @param [Time] value
      #
      # @return [DateTime]
      #
      # @api public
      def to_datetime(value)
        if value.respond_to?(:to_datetime)
          value.to_datetime
        else
          String.to_datetime(to_string(value))
        end
      end

      # Coerce given value to Date
      #
      # @example
      #   Virtus::Coercion::Time.to_date(date)  # => Date object
      #
      # @param [Time] value
      #
      # @return [Date]
      #
      # @api public
      def to_date(value)
        if value.respond_to?(:to_date)
          value.to_date
        else
          String.to_date(to_string(value))
        end
      end

    end # module TimeCoercions
  end # class Coercion
end # module Virtus
