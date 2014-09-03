module Virtus
  class Attribute

    module LazyDefault

      # @api public
      def get(instance)
        if present?(instance)
          super
        else
          set_default_value(instance)
        end
      end

    end # LazyDefault

  end # Attribute
end # Virtus
