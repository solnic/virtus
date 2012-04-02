module Virtus
  class Attribute
    class DefaultValue

      # Represents default value evaluated via a clonable object
      #
      # @api private
      class FromClonable < DefaultValue
        SINGLETON_CLASSES = [
          ::NilClass, ::TrueClass, ::FalseClass, ::Numeric,  ::Symbol ].freeze

        # Return if the class can handle the value
        #
        # @return [Boolean]
        #
        # @api private
        def self.handle?(attribute, value)
          case value
          when *SINGLETON_CLASSES
            false
          else
            true
          end
        end

        # Evaluates the value via value#clone
        #
        # @param [Object]
        #
        # @return [Object] evaluated value
        #
        # @api private
        def call(instance)
          @value.clone
        end

      end # class FromClonable
    end # class DefaultValue
  end # class Attribute
end # module Virtus

