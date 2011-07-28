module Virtus
  class Coercion

    # Coerce Float values
    class Float < Numeric
      primitive ::Float

      # Passthrough the value
      #
      # @example
      #   Virtus::Coercion::Float.to_float(1.0)  # => 1.0
      #
      # @param [Float] value
      #
      # @return [Integer]
      #
      # @api public
      def self.to_float(value)
        value
      end

    end # class Float
  end # class Coercion
end # module Virtus
