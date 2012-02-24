module Virtus
  class Attribute

    # Class representing the default value option
    class DefaultValue
      SINGLETON_CLASSES = [ ::NilClass, ::TrueClass, ::FalseClass,
                            ::Numeric,  ::Symbol ].freeze

      # @api public
      def self.build(instance, value)
        if value.is_a?(Symbol) && instance.respond_to?(value)
          DefaultValueFromMethod.new(instance, value)
        elsif value.respond_to?(:call)
          DefaultValueFromCallable.new(instance, value)
        elsif cloneable?(value)
          DefaultValueFromClonable.new(instance, value)
        else
          DefaultValue.new(instance, value)
        end
      end

      # Returns whether or not the value is cloneable
      #
      # return [TrueClass, FalseClass]
      #
      # @api private
      def self.cloneable?(value)
        case value
        when *SINGLETON_CLASSES then false
        else
          true
        end
      end

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
        value
      end
    end # class DefaultValue

    class DefaultValueFromMethod < DefaultValue

      # @api private
      def evaluate(instance)
        instance.send(value)
      end

    end

    class DefaultValueFromCallable < DefaultValue

      # @api private
      def evaluate(instance)
        value.call(instance, attribute)
      end

    end

    class DefaultValueFromClonable < DefaultValue

      # @api private
      def evaluate(instance)
        value.clone
      end

    end

  end # class Attribute
end # module Virtus
