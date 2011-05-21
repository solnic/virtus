module Virtus
  module Attributes
    module Typecast
      module Numeric
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
        def typecast_to_numeric(value, method)
          if value.respond_to?(:to_str)
            if value.to_str =~ /\A(-?(?:0|[1-9]\d*)(?:\.\d+)?|(?:\.\d+))\z/
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
      end # Numeric
    end # Typecast
  end # Attributes
end # Virtus
