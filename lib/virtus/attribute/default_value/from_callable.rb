module Virtus
  class Attribute
    class DefaultValue

      # Represents default value evaluated via a callable object
      #
      # @api private
      class FromCallable < DefaultValue

        # Return if the class can handle the value
        #
        # @return [Boolean]
        #
        # @api private
        def self.handle?(attribute, value)
          value.respond_to?(:call)
        end

        # Evaluates the value via value#call
        #
        # @param [Object]
        #
        # @return [Object] evaluated value
        #
        # @api private
        def evaluate(instance)
          @value.call(instance, @attribute)
        end

      end # class FromCallable
    end # class DefaultValue
  end # class Attribute
end # module Virtus
