module Virtus
  class Attribute

    # Integer
    #
    # @example
    #   class Post
    #     include Virtus
    #
    #     attribute :read_count, Integer
    #   end
    #
    #   Post.new(:read_count => 100)
    #
    #   # typecasting from a string
    #   Post.new(:read_count => '100')
    #
    #   # typecasting from an object that implements #to_i
    #   Post.new(:read_count => 100.0)
    #
    class Integer < Numeric
      primitive       ::Integer
      coercion_method :to_integer

    end # class Integer
  end # class Attribute
end # module Virtus
