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

      # Coerce given value to a DateTime
      #
      # @example
      #   datetime = Virtus::Coercion::Float.to_datetime(1000000000.999)  # => Sun, 09 Sep 2001 01:46:40 +0000
      #   datetime.to_f  # => 1000000000.999
      #
      # @param [Float] value
      #
      # @return [DateTime]
      #
      # @api public
      def self.to_datetime(value)
        ::DateTime.strptime((value * 10**3).to_s, "%Q")
      end

    end # class Float
  end # class Coercion
end # module Virtus
