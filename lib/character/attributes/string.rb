module Character
  module Attributes
    class String < Object
      primitive ::String

      def typecast(value, model)
        value.to_s
      end
    end # String
  end # Attributes
end # Character
