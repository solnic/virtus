module Virtus
  module Typecast

    # Float
    #
    class Float < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::Fixnum.to_string(0.10) # => "0.10"
      #
      # @param [Fixnum] value
      #
      # @return [String]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # @api public
      def self.to_integer(value)
        value.to_i
      end

      # @api public
      def self.to_decimal(value)
        to_string(value).to_d
      end

    end # class Float
  end # module Typecast
end # module Virtus
