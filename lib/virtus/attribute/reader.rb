module Virtus
  class Attribute

    class Reader

      attr_reader :name

      # @api private
      def initialize(name, visibility)
        @name                   = name.to_sym
        @visibility             = visibility
        @instance_variable_name = "@#{name}".to_sym
      end

      # Returns value of an attribute for the given instance
      #
      # @example
      #   attribute.get(instance)  # => value
      #
      # @return [Object]
      #   value of an attribute
      #
      # @api public
      def get(instance)
        instance.instance_variable_get(@instance_variable_name)
      end

      # @api public
      def public?
        @visibility == :public
      end

    end # class Reader

  end # class Attribute
end # module Virtus
