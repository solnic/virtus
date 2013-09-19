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
        # @param [Object] value
        #
        # @return [Boolean]
        #
        # @api private
        def self.handle?(value)
          SINGLETON_CLASSES.none? { |klass| value.kind_of?(klass) }
        end

        # Evaluates the value via value#clone
        #
        # @return [Object] evaluated value
        #
        # @api private
        def call(*)
          @value.clone
        end

      end # class FromClonable
    end # class DefaultValue
  end # class Attribute
end # module Virtus
