module Virtus
  class Attribute

    module Strict

      # @api public
      def coerce(input)
        coerced = super
        raise ArgumentError unless coercer.success?(primitive, coerced)
        coerced
      end

    end # Strict

  end # Attribute
end # Virtus
