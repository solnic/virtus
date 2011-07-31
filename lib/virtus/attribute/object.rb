module Virtus
  class Attribute

    # Base class for every attribute
    class Object < Attribute
      primitive       ::Object
      coercion_method :to_object

    end # class Object
  end # class Attribute
end # module Virtus
