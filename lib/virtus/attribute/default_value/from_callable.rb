module Virtus
  class Attribute
    class DefaultValue

      # Represents default value evaluated via a callable object
      #
      # @api private
      class FromCallable < DefaultValue

        # Return if the class can handle the value
        #
        # @param [Object] value
        #
        # @return [Boolean]
        #
        # @api private
        def self.handle?(value)
          value.respond_to?(:call)
        end

        # Evaluates the value via value#call
        #
        # @param [Object] args
        #
        # @return [Object] evaluated value
        #
        # @api private
        def call(*args)
          @value.call(*args)
        end

      end # class FromCallable
    end # class DefaultValue
  end # class Attribute
end # module Virtus
