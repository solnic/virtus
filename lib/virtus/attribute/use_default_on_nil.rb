module Virtus
  class Attribute

    # Attribute extension which falls back nil attributes to default value
    #
    module UseDefaultOnNil

      # @see [Attribute#coerce]
      #
      # @api public
      def coerce(input)
        output = super

        if !value_coerced?(output) && input.nil?
          super(default_value.value)
        else
          output
        end
      end

    end # UseDefaultOnNil

  end # Attribute
end # Virtus
