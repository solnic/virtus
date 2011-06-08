module Virtus
  class Attribute
    class Boolean < Object
      primitive TrueClass

      # @api private
      def primitive?(value)
        value.equal?(true) || value.equal?(false)
      end

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
