module Virtus
  module Typecast

    # Fixnum
    #
    class Fixnum < Object

      # Typecast given value to String
      #
      # @example
      #   Virtus::Typecast::Float.to_string(0.10) # => "0.10"
      #
      # @param [Object] value
      #
      # @return [#to_s]
      #
      # @api public
      def self.to_string(value)
        value.to_s
      end

      # @api public
      def self.to_f(value)
        value.to_f
      end

      # @api public
      def self.to_d(value)
        to_string(value).to_d
      end

      # @api public
      def self.to_boolean(value)
        value == 1
      end

    end # class Fixnum
  end # module Typecast
end # module Virtus
