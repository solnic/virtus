module Virtus
  class Coercion

    # Coerce Date values
    class Date < Object
      extend TimeCoercions

      primitive ::Date

      # Passthrough the value
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
        value
      end

    end # class Date
  end # class Coercion
end # module Virtus
