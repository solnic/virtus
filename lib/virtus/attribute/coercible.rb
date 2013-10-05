module Virtus
  class Attribute

    # Attribute extension providing coercion when setting an attribute value
    #
    module Coercible

      # Coerce value before setting
      #
      # @see Accessor#set
      #
      # @api public
      def set(instance, value)
        super(instance, coerce(value))
      end

    end # Coercible

  end # Attribute
end # Virtus
