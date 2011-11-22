module Virtus
  class Attribute

    # Bolean attribute allows true or false values to be set
    # Additionally it adds boolean reader method, like "admin?"
    #
    # @example
    #   class Post
    #     include Virtus
    #
    #     attribute :published, Boolean
    #   end
    #
    #   post = Post.new(:published => false)
    #   post.published?  # => false
    #
    class Boolean < Object
      primitive       TrueClass
      coercion_method :to_boolean

      # Returns if the given value is either true or false
      #
      # @example
      #   Virtus::Attribute::Boolean.primitive?(true)    # => true
      #   Virtus::Attribute::Boolean.primitive?(false)   # => true
      #   Virtus::Attribute::Boolean.primitive?(1)       # => false
      #   Virtus::Attribute::Boolean.primitive?('true')  # => false
      #
      # @return [Boolean]
      #
      # @api public
      def self.primitive?(value)
        value.equal?(true) || value.equal?(false)
      end

      # Query for the list of reader method names defined for this Attribute
      #
      # @return [Array(Symbol)]
      #
      # @api private
      def reader_method_names
        super + ["#{name}?"]
      end

    end # class Boolean
  end # class Attribute
end # module Virtus
