module Virtus
  class Attribute

    # Class representing the default value option
    class DefaultValue
      DUP_CLASSES = [ ::NilClass, ::TrueClass, ::FalseClass,
                      ::Numeric,  ::Symbol ].freeze

      # Returns the attribute associated with this default value instance
      #
      # @return [Virtus::Attribute::Object]
      #
      # @api private
      attr_reader :attribute

      # Returns the value instance
      #
      # @return [Object]
      #
      # @api private
      attr_reader :value

      # Initializes an default value instance
      #
      # @param [Virtus::Attribute] attribute
      # @param [Object] value
      #
      # @return [undefined]
      #
      # @api private
      def initialize(attribute, value)
        @attribute, @value = attribute, value
      end

      # Evaluates the value
      #
      # @param [Object]
      #
      # @return [Object] evaluated value
      #
      # @api private
      def evaluate(instance)
        if callable?
          call(instance)
        elsif duplicable?
          value.dup
        else
          value
        end
      end

    private

      # Evaluates a proc value
      #
      # @param [Object]
      #
      # @return [Object] evaluated value
      #
      # @api private
      def call(instance)
        value.call(instance, attribute)
      end

      # Returns if the value is callable
      #
      # @return [TrueClass,FalseClass]
      #
      # @api private
      def callable?
        value.respond_to?(:call)
      end

      # Returns whether or not the value is duplicable
      #
      # # return [TrueClass, FalseClass]
      #
      # @api private
      def duplicable?
        case value when *DUP_CLASSES then false else true end
      end

    end # class DefaultValue
  end # class Attribute
end # module Virtus
