module Virtus
  class Attribute

    # Bolean attribute allows true or false values to be set
    # Additionally it adds boolean reader method, like "admin?"
    #
    # Example usage:
    #
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
      primitive TrueClass

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

      # Coerce value into true or false
      #
      # @see Virtus::Typecast::Boolean.call
      #
      # @return [Boolean]
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Boolean.call(value)
      end

      # Creates standard and boolean attribute reader methods
      #
      # @param [Class] model
      #
      # @return [self]
      #
      # @api private
      def add_reader_method(model)
        super

        reader_method_name = "#{name}?"
        reader_visibility  = self.reader_visibility
        attribute          = self

        model::AttributeMethods.class_eval do
          define_method(reader_method_name) { attribute.get(self) }
          send(reader_visibility, reader_method_name)
        end

        model.class_eval { include self::AttributeMethods }

        self
      end

    end # class Boolean
  end # class Attribute
end # module Virtus
