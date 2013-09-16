module Virtus
  class Attribute

    module Named

      # @api public
      def name
        options[:name]
      end

      # @api public
      def get(instance)
        instance.instance_variable_get(instance_variable_name)
      end

      # @api public
      def set(instance, value)
        instance.instance_variable_set(instance_variable_name, value)
      end

      # @api public
      def set_default_value(instance)
        set(instance, default_value.call(instance, self))
      end

      # Returns a Boolean indicating whether the reader method is public
      #
      # @return [Boolean]
      #
      # @api private
      def public_reader?
        options[:reader] == :public
      end

      # Returns a Boolean indicating whether the writer method is public
      #
      # @return [Boolean]
      #
      # @api private
      def public_writer?
        options[:writer] == :public
      end

      # @api private
      def instance_variable_name
        "@#{name}"
      end

    end # Named

  end # Attribute
end # Virtus
