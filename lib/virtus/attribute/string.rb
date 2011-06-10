module Virtus
  class Attribute
    # Example usage
    #
    #   class User
    #     include Virtus
    #
    #     attribute :name, String
    #   end
    #
    #   User.new(:name => 'John')
    #
    #   # typecasting from an object which implements #to_s
    #   User.new(:name => :John)
    #
    class String < Object
      primitive ::String

      # @see Virtus::Typecast::String.call
      #
      # @api private
      def typecast_to_primitive(value)
        Virtus::Typecast::String.call(value)
      end
    end # String
  end # Attributes
end # Virtus
