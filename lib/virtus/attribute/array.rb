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
      primitive ::Array
      complex   true
    end # class Array
  end # class Attribute
end # module Virtus
