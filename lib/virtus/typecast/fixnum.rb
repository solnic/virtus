module Virtus
  module Typecast

    # Fixnum
    #
    class Fixnum < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::Fixnum.to_string(1) # => "1"
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
      def self.to_float(value)
        value.to_f
      end

      # @api public
      def self.to_decimal(value)
        to_string(value).to_d
      end

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
