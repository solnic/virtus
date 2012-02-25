module Virtus
  class Attribute
    class DefaultValue

      # Represents default value evaluated via a symbol
      #
      # @api private
      class FromSymbol < DefaultValue
        # @api private
        def self.handle?(attribute, value)
          value.is_a?(::Symbol)
        end

        # @api private
        def evaluate(instance)
          instance.respond_to?(value) ? instance.__send__(value) : value
        end

      end # class FromSymbol
    end # class DefaultValue
  end # class Attribute
end # module Virtus
