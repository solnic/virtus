module Virtus
  class Attribute
    class String < Object
      primitive ::String

      def typecast_to_primitive(value)
        value.to_s
      end
    end # String
  end # Attributes
end # Virtus
