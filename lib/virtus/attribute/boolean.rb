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
      #   boolean = Virtus::Attribute::Boolean.new(:bool)
      #   boolean.primitive?(true)    # => true
      #   boolean.primitive?(false)   # => true
      #   boolean.primitive?(1)       # => false
      #   boolean.primitive?('true')  # => false
      #
      # @return [Boolean]
      #
      # @api public
      def value_coerced?(value)
        value.equal?(true) || value.equal?(false)
      end

      # Creates standard and boolean attribute reader methods
      #
      # @param [Module] mod
      #
      # @return [self]
      #
      # @api private
      def define_reader_method(mod)
        super

        reader_method_name = "#{name}?"
        attribute          = self

        mod.send(:define_method,    reader_method_name) { attribute.get(self) }
        mod.send(reader_visibility, reader_method_name)

        self
      end

    end # class Boolean
  end # class Attribute
end # module Virtus
