module Virtus
  class Coercion

    # Coerce DateTime values
    class DateTime < Object

      # Coerce given value to String
      #
      # @example
      #   Virtus::Coercion::DateTime.to_string(date_time)  # => "2011-07-20T10:30:41-07:00"
      #
      # @param [DateTime] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # Coerce given value to Date
      #
      # @example
      #   Virtus::Coercion::DateTime.to_date(date)  # => Date object
      #
      # @param [DateTime] value
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
      def self.to_time(value)
        if value.respond_to?(:to_time)
          value.to_time
        else
          String.to_time(to_string(value))
        end
      end

    end # class DateTime
  end # class Coercion
end # module Virtus
