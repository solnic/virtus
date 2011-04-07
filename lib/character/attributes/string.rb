module Character
  module Attributes
    class String < Object
      primitive ::String

      def typecast(value, model = nil)
        value.to_s
      end
    end # String
  end # Attributes
end # Character
