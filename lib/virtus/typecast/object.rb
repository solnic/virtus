module Virtus
  module Typecast

    # Object
    #
    class Object

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
  end # module Typecast
end # module Virtus
