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
    class Array < Collection
      primitive       ::Array
      coercion_method :to_array

      def coerce_and_append_member(collection, entry)
        collection << @member_type_instance.coerce(entry)
      end

    end # class Array
  end # class Attribute
end # module Virtus
