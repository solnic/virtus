module Character
  module Attribute
    class String < Object
      primitive ::String

      def typecast(value, model)
        value.to_s
      end
    end # String
  end # Attribute
end # Character
