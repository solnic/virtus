module Virtus
  module Attributes
    class String < Object
      primitive ::String

      def typecast_to_primitive(value, model = nil)
        value.to_s
      end
    end # String
  end # Attributes
end # Virtus
