module Virtus
  class Attribute

    # Class representing the default value option
    class DefaultValue
      extend DescendantsTracker

      class FromClonable < DefaultValue
        SINGLETON_CLASSES = [ ::NilClass, ::TrueClass, ::FalseClass,
                              ::Numeric,  ::Symbol ].freeze

        # @api private
        def self.handle?(attribute, value)
          case value
          when *SINGLETON_CLASSES
            false
          else
            true
          end
        end

        # @api private
        def evaluate(instance)
          value.clone
        end

      end # class FromClonable

      class FromCallable < DefaultValue

        # @api private
        def self.handle?(attribute, value)
          value.respond_to?(:call)
        end

        # @api private
        def evaluate(instance)
          value.call(instance, attribute)
        end

      end # class FromCallable

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

      # @api public
      def self.build(*args)
        klass = descendants.detect { |descendant| descendant.handle?(*args) } || self
        klass.new(*args)
      end

      # Returns whether or not the value is cloneable
      #
      # return [TrueClass, FalseClass]
      #
      # @api private
      def self.cloneable?(value)

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

  end # class Attribute
end # module Virtus
