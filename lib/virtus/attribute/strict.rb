module Virtus
  class Attribute

    module Strict

      # @api public
      def coerce(*)
        output = super

        if coercer.success?(primitive, output) || !required? && output.nil?
          output
        else
          raise CoercionError.new(output, primitive)
        end
      end

    end # Strict

  end # Attribute
end # Virtus
