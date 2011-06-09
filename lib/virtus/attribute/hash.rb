module Virtus
  class Attribute
    # Example usage:
    #
    #   class Post
    #     include Virtus
    #
    #     attribute :meta, Hash
    #   end
    #
    #   Post.new(:meta => { :tags => %w(foo bar) })
    #
    class Hash < Object
      primitive ::Hash
      complex   true
    end # Integer
  end # Attributes
end # Virtus
