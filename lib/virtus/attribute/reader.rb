module Virtus
  class Attribute

    class Reader

      attr_reader :name

      attr_reader :visibility

      attr_reader :instance_variable_name

      # @api private
      def initialize(name, options = {})
        @name                   = name.to_sym
        @visibility             = options.fetch(:visibility, :public)
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

      # Creates an attribute reader method
      #
      # @param [Module] mod
      #
      # @return [self]
      #
      # @api private
      def define_method(accessor, mod)
        mod.define_reader_method(accessor, name, visibility)
        self
      end

    end # class Reader

  end # class Attribute
end # module Virtus
