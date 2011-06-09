module Virtus
  module Typecast
    # Typecast numeric values. Supports Integer, Float and BigDecimal
    class Numeric
      # Typecast value to integer
      #
      # @param [Object]
      #
      # @return [Integer]
      #
      # @api public
      def self.to_i(value)
        call(value, :to_i)
      end

      # Typecast value to float
      #
      # @param [Object]
      #
      # @return [Float]
      #
      # @api public
      def self.to_f(value)
        call(value, :to_f)
      end

      # Typecast value to decimal
      #
      # @param [Object]
      #
      # @return [BigDecimal]
      #
      # @api public
      def self.to_d(value)
        if value.kind_of?(::Integer)
          value.to_s.to_d
        else
          call(value, :to_d)
        end
      end

      private

      # Match numeric string
      #
      # @param [#to_str, Numeric] value
      #   value to typecast
      # @param [Symbol] method
      #   method to typecast with
      #
      # @return [Numeric]
      #   number if matched, value if no match
      #
      # @api private
      def self.call(value, method)
        if value.respond_to?(:to_str)
          if value.to_str =~ /\A(-?(?:0|[1-9]\d*)(?:\.\d+)?|(?:\.\d+))\z/
            $1.send(method)
          else
            value
          end
        elsif value.respond_to?(method)
          value.send(method)
        else
          value
        end
      end
    end # Numeric
  end # Typecast
end # Virtus
