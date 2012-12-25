module Virtus
  class Attribute

    # Adds coercion to attributes
    #
    module Coercion

      # @see Attribute#set
      #
      # @api public
      def set(instance, value)
        super(instance, coerce(value))
      end

    end # module Coerce

  end # class Attribute
end # module Virtus
