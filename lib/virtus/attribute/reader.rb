module Virtus
  class Attribute

    class Reader < AccessorMethod

      # Returns value of an attribute for the given instance
      #
      # @example
      #   attribute.get(instance)  # => value
      #
      # @return [Object]
      #   value of an attribute
      #
      # @api public
      def call(instance)
        instance.instance_variable_get(instance_variable_name)
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
