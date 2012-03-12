module Virtus
  class Attribute
    class DefaultValue

      # Represents default value evaluated via a symbol
      #
      # @api private
      class FromSymbol < DefaultValue

        # Return if the class can handle the value
        #
        # @return [Boolean]
        #
        # @api private
        def self.handle?(attribute, value)
          value.is_a?(::Symbol)
        end

        # Evaluates the value via instance#public_send(value)
        #
        # Symbol value is returned if the instance doesn't respond to value
        #
        # @param [Object]
        #
        # @return [Object] evaluated value
        #
        # @api private
        def evaluate(instance)
          instance.respond_to?(@value) ? instance.public_send(@value) : @value
        end

      end # class FromSymbol
    end # class DefaultValue
  end # class Attribute
end # module Virtus
