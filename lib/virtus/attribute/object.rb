module Virtus
  class Attribute

    # Base class for every attribute
    class Object < Attribute
      primitive ::Object
      complex   false
    end # Object
  end # Attributes
end # Virtus
