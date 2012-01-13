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

      # Coerce a member of a source collection and append it to the target collection
      #
      # @param [Array, Set] collection
      #   target collection to which the coerced member should be appended
      #
      # @param [Object] entry
      #   the member that should be coerced and appended
      #
      # @return [Array, Set]
      #   collection with the coerced member appended to it
      #
      # @api private
      def coerce_and_append_member(collection, entry)
        collection << @member_type_instance.coerce(entry)
      end

    end # class Array
  end # class Attribute
end # module Virtus
