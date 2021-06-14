module Virtus
  class Attribute

    # An "ancestor" for both TrueClass and FalseClass
    # Used to correctly build Attribute::Boolean from
    # true or false
    #
    # Needs to be a descendant of TrueClass in order
    # to allow Axiom::Type.infer to infer
    # Axiom::Types::Boolean from BooleanPrimitive
    #
    # @private
    class BooleanPrimitive < TrueClass
      def self.>=(klass)
        TrueClass >= klass || FalseClass >= klass
      end
    end

    # Boolean attribute allows true or false values to be set
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
    class Boolean < Attribute
      primitive BooleanPrimitive

      # @api private
      def self.build_type(*)
        Axiom::Types::Boolean
      end

      # Returns if the given value is either true or false
      #
      # @example
      #   boolean = Virtus::Attribute::Boolean.new(:bool)
      #   boolean.value_coerced?(true)    # => true
      #   boolean.value_coerced?(false)   # => true
      #   boolean.value_coerced?(1)       # => false
      #   boolean.value_coerced?('true')  # => false
      #
      # @return [Boolean]
      #
      # @api public
      def value_coerced?(value)
        value.equal?(true) || value.equal?(false)
      end

      # Creates an attribute reader method as a query
      #
      # @param [Module] mod
      #
      # @return [undefined]
      #
      # @api private
      def define_accessor_methods(attribute_set)
        super
        attribute_set.define_reader_method(self, "#{name}?", options[:reader])
      end

    end # class Boolean
  end # class Attribute
end # module Virtus
