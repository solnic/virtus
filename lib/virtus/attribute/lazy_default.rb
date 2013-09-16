module Virtus
  class Attribute

    module LazyDefault

      # @api public
      def get(instance)
        if instance.instance_variable_defined?(instance_variable_name)
          super
        else
          set_default_value(instance)
        end
      end

    end # LazyDefault

  end # Attribute
end # Virtus
