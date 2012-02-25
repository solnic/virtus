module Virtus
  class Attribute

    # Class representing the default value option
    #
    # @api private
    class DefaultValue
      extend DescendantsTracker

      # Builds a default value instance
      #
      # @return [Virtus::Attribute::DefaultValue]
      #
      # @api private
      def self.build(*args)
        klass = descendants.detect { |descendant| descendant.handle?(*args) } || self
        klass.new(*args)
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
