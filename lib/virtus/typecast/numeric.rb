module Virtus
  module Typecast

    # Typecast numeric values. Supports Integer, Float and BigDecimal
    class Numeric

      REGEXP = /\A(-?(?:0|[1-9]\d*)(?:\.\d+)?|(?:\.\d+))\z/.freeze

      # Typecast value to integer
      #
      # @example
      #   Virtus::Typecast::Numeric.to_i('1')  # => 1
      #   Virtus::Typecast::Numeric.to_i(1.2)  # => 1
      #
      # @param [Object] value
      #
      # @return [Integer]
      #
      # @api public
      def self.to_i(value)
        call(value, :to_i)
      end

      # Typecast value to float
      #
      # @example
      #   Virtus::Typecast::Numeric.to_f('1.2')  # => 1.2
      #   Virtus::Typecast::Numeric.to_f(1)      # => 1.0
      #
      # @param [Object] value
      #
      # @return [Float]
      #
      # @api public
      def self.to_f(value)
        call(value, :to_f)
      end

      # Typecast value to decimal
      #
      # @example
      #   Virtus::Typecast::Numeric.to_d('1.2')  # => #<BigDecimal:b72157d4,'0.12E1',8(8)>
      #   Virtus::Typecast::Numeric.to_d(1)      # => #<BigDecimal:b7212e08,'0.1E1',4(8)>
      #
      # @param [Object] value
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
          if value.to_str =~ REGEXP
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

      private_class_method :call

    end # class Numeric
  end # module Typecast
end # module Virtus
