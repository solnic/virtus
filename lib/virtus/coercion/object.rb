module Virtus
  class Coercion

    # Coerce Object values
    class Object < Coercion

      # Passthrough given value
      #
      # @param [Object] value
      #
      # @return [Object]
      #
      # @api private
      def self.method_missing(method, *args)
        if method.to_s[0, 3] == 'to_' && args.size == 1
          args.first
        else
          super
        end
      end

    end # class Object
  end # class Coercion
end # module Virtus
