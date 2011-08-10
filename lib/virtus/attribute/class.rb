module Virtus
  class Attribute

    # Class
    #
    # @example
    #   class Entity
    #     include Virtus
    #
    #     attribute :type, Class
    #   end
    #
    #   post = Entity.new(:model => Model)
    #
    class Class < Object
      primitive       ::Class
      coercion_method :to_constant

    end # class Class
  end # class Attribute
end # module Virtus
