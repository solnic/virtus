module Virtus
  class Attribute

    # Hash
    #
    # @example
    #   class Post
    #     include Virtus
    #
    #     attribute :meta, Hash
    #   end
    #
    #   Post.new(:meta => { :tags => %w(foo bar) })
    #
    class Hash < Object
      primitive       ::Hash
      typecast_method :to_hash
      complex         true

    end # class Hash
  end # class Attribute
end # module Virtus
