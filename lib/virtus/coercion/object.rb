module Virtus
  class Coercion

    # Coerce Object values
    class Object < Coercion
      primitive ::Object

      COERCION_METHOD_REGEXP = /\Ato_/.freeze

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
