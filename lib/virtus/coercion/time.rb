module Virtus
  class Coercion

    # Coerce Time values
    class Time < Object
      extend TimeCoercions

      primitive ::Time

      # Passthrough the value
      #
      # @example
      #   Virtus::Coercion::DateTime.to_time(time)  # => Time object
      #
      # @param [DateTime] value
      #
      # @return [Date]
      #
      # @api public
      def self.to_time(value)
        value
      end

    end # class Time
  end # class Coercion
end # module Virtus
