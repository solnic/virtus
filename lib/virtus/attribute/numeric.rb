module Virtus
  class Attribute

    # Base class for all numerical attributes
    class Numeric < Object
      primitive      ::Numeric
      accept_options :min, :max

    end # class Numeric
  end # class Attribute
end # module Virtus
