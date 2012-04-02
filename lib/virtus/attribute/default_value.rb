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

      # Returns the value instance
      #
      # @return [Object]
      #
      # @api private
      attr_reader :value

      # Initializes an default value instance
      #
      # @param [Object] value
      #
      # @return [undefined]
      #
      # @api private
      def initialize(value)
        @value = value
      end

      # Evaluates the value
      #
      # @return [Object] evaluated value
      #
      # @api private
      def call(*)
        value
      end

    end # class DefaultValue
  end # class Attribute
end # module Virtus
