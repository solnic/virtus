module Virtus
  module Typecast

    # Fixnum
    #
    class Fixnum < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::Fixnum.to_string(1)  # => "1"
      #
      # @param [Fixnum] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # Typecast given value to Float
      #
      # @example
      #   Virtus::Typecast::Fixnum.to_float(1)  # => 1.0
      #
      # @param [Fixnum] value
      #
      # @return [Float]
      #
      # @api public
      def self.to_float(value)
        value.to_f
      end

      # Typecast given value to BigDecimal
      #
      # @example
      #   Virtus::Typecast::Fixnum.to_decimal(1)  # => BigDecimal('1.0')
      #
      # @param [Fixnum] value
      #
      # @return [BigDecimal]
      #
      # @api public
      def self.to_decimal(value)
        to_string(value).to_d
      end

      # Typecast given value to a Boolean
      #
      # @example with a 1
      #   Virtus::Typecast::Fixnum.to_boolean(1)  # => true
      #
      # @example with a 0
      #   Virtus::Typecast::Fixnum.to_boolean(0)  # => false
      #
      # @param [Fixnum] value
      #
      # @return [BigDecimal]
      #
      # @api public
      def self.to_boolean(value)
        case value
        when 1 then true
        when 0 then false
        else
          value
        end
      end

    end # class Fixnum
  end # module Typecast
end # module Virtus
