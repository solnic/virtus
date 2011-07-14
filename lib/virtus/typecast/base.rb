module Virtus
  module Typecast

    # Base typecast class
    class Base

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

      # Passthrough give value
      #
      # @return [Object]
      #
      # @api private
      def self.to_boolean(value)
        value
      end

      # Passthrough give value
      #
      # @return [Object]
      #
      # @api private
      def self.to_i(value)
        value
      end

      # Passthrough give value
      #
      # @return [Object]
      #
      # @api private
      def self.to_f(value)
        value
      end

      # Passthrough give value
      #
      # @return [Object]
      #
      # @api private
      def self.to_d(value)
        value
      end
    end # class Base
  end # module Typecast
end # module Virtus
