module Virtus
  class Attribute
    # Base class for all numerical attributes
    class Numeric < Object
      accept_options :min, :max
    end # Numeric
  end # Attributes
end # Virtus
