module Virtus
  class Attribute

    # Attribute extension which nullifies blank attributes when coercion failed
    #
    module NullifyBlank

      # @see [Attribute#coerce]
      #
      # @api public
      def coerce(input)
        output = super

        if !value_coerced?(output) && input.to_s.empty?
          nil
        else
          output
        end
      end

    end # NullifyBlank

  end # Attribute
end # Virtus
