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

      # Typecast the given value to a string
      #
      # @param [Object]
      #
      # @return [String]
      #
      # @api private
      def typecast_to_primitive(value)
        value.to_s
      end
    end # String
  end # Attributes
end # Virtus
