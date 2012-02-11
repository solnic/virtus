module Virtus
  class Coercion

    # Coerce Object values
    class Object < Coercion
      primitive ::Object

      COERCION_METHOD_REGEXP = /\Ato_/.freeze

      # Create an Array from any Object
      #
      # @param [#to_a,#to_ary,Object] value
      #
      # @return [Array]
      #
      # @api public
      def self.to_array(value)
        Array(value)
      end

      # Create a Hash from the Object if possible
      #
      # @overload value is coercible into Hash
      #
      #   @param [#to_hash] value
      #
      #   @return [Hash]
      #
      # @overload value is not coercible into Hash
      #
      #   @param [Object] value
      #
      #   @return [Object]
      #
      # @api public
      def self.to_hash(value)
        value.respond_to?(:to_hash) ? value.to_hash : value
      end

      # Passthrough given value
      #
      # @param [Object] value
      #
      # @return [Object]
      #
      # @api private
      def self.method_missing(method, *args)
        if method.to_s =~ COERCION_METHOD_REGEXP && args.size == 1
          args.first
        else
          super
        end
      end

      private_class_method :method_missing

    end # class Object
  end # class Coercion
end # module Virtus
