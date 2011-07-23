module Virtus
  class Attribute

    # Array
    #
    # @example
    #   class Post
    #     include Virtus
    #
    #     attribute :tags, Array
    #   end
    #
    #   post = Post.new(:tags => %w(red green blue))
    #
    class Array < Object
      primitive       ::Array
      typecast_method :to_array
      complex         true
    end # class Array
  end # class Attribute
end # module Virtus
