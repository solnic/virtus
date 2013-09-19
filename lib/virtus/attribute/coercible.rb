module Virtus
  class Attribute

    module Coercible

      # @api public
      def set(instance, value)
        super(instance, coerce(value))
      end

    end # Coercible

  end # Attribute
end # Virtus
