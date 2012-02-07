module Virtus
  class Coercion

    # Coerce Array values
    class Array < Object
      primitive ::Array

      TIME_SEGMENTS = [ :year, :month, :day, :hour, :min, :sec ].freeze

      # Creates a Set instance from an Array
      #
      # @param [Array] value
      #
      # @return [Array]
      #
      # @api private
      def self.to_set(value)
        value.to_set
      end

    end # class Array
  end # class Coercion
end # module Virtus
