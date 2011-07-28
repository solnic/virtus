module Virtus
  class Coercion

    # Coerce DateTime values
    class DateTime < Object
      primitive ::DateTime

      extend TimeCoercions

      # Passthrough the value
      #
      # @example
      #   Virtus::Coercion::DateTime.to_datetime(datetime)  # => DateTime object
      #
      # @param [DateTime] value
      #
      # @return [Date]
      #
      # @api public
      def self.to_datetime(value)
        value
      end

    end # class DateTime
  end # class Coercion
end # module Virtus
