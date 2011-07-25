module Virtus
  class Attribute

    # String
    #
    # @example
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #   end
    #
    #   User.new(:name => 'John')
    #
    #   # typecasting from an object which implements #to_s
    #   User.new(:name => :John)
    #
    class String < Object
      primitive       ::String
      coercion_method :to_string

    end # class String
  end # class Attribute
end # module Virtus
