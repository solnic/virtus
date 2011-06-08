module Virtus
  class Attribute
    class Numeric < Object
      include Typecast::Numeric

      accept_options :min, :max
    end # Numeric
  end # Attributes
end # Virtus
