module Virtus
  class Coercion

    # Common time coercion methods
    module TimeCoercions

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::Time.to_string(time)  # => "Wed Jul 20 10:30:41 -0700 2011"
      #
      # @param [Date,Time,DateTime] value
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
      #   Virtus::Coercion::DateTime.to_time(datetime)  # => Time object
      #
      # @param [Date,DateTime] value
      #
      # @return [Time]
      #
      # @api public
      def to_time(value)
        coerce_with_method(value, :to_time)
      end

      # Coerce given value to DateTime
      #
      # @example
      #   Virtus::Coercion::Time.to_datetime(time)  # => DateTime object
      #
      # @param [Date,Time] value
      #
      # @return [DateTime]
      #
      # @api public
      def to_datetime(value)
        coerce_with_method(value, :to_datetime)
      end

      # Coerce given value to Date
      #
      # @example
      #   Virtus::Coercion::Time.to_date(time)  # => Date object
      #
      # @param [Time,DateTime] value
      #
      # @return [Date]
      #
      # @api public
      def to_date(value)
        coerce_with_method(value, :to_date)
      end

    private

      # Try to use native coercion method on the given value
      #
      # Falls back to String-based parsing
      #
      # @param [Date,DateTime,Time] value
      # @param [Symbol] method
      #
      # @return [Date,DateTime,Time]
      #
      # @api private
      def coerce_with_method(value, method)
        coerced = super
        if coerced.equal?(value)
          String.public_send(method, to_string(value))
        else
          coerced
        end
      end

    end # module TimeCoercions
  end # class Coercion
end # module Virtus
