module Virtus
  class Attribute

    # Set
    #
    # @example
    #   class Post
    #     include Virtus
    #
    #     attribute :tags, Set
    #   end
    #
    #   post = Post.new(:tags => %w(red green blue))
    #
    class Set < Collection
      primitive       ::Set
      coercion_method :to_set
      default         primitive.new

      include Collection::MemberCoercion

    end # class Set
  end # class Attribute
end # module Virtus
