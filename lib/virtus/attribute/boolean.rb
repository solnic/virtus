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
    #   post.published? # => false
    #
    class Boolean < Object
      primitive TrueClass

      # Returns if the given value is either true or false
      #
      # @return [TrueClass,FalseClass]
      #
      # @api private
      def primitive?(value)
        value.equal?(true) || value.equal?(false)
      end

      # Coerce value into true or false
      #
      # @see Virtus::Typecast::Boolean.call
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Boolean.call(value)
      end

      # Creates standard and boolean attribute reader methods
      #
      # @api private
      def add_reader_method(model)
        super

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          chainable(:attribute) do
            #{reader_visibility}

            def #{name}?
              #{name}
            end
          end
        RUBY
      end
    end # Boolean
  end # Attributes
end # Virtus
