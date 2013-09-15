module Virtus
  class Attribute

    # EmbeddedValue
    #
    # @example
    #
    #   class Address
    #     include Virtus
    #
    #     attribute :street,  String
    #     attribute :zipcode, String
    #     attribute :city,    String
    #   end
    #
    #   class User
    #     include Virtus
    #
    #     attribute :address, Address
    #   end
    #
    #   user = User.new(:address => {
    #     :street => 'Street 1/2', :zipcode => '12345', :city => 'NYC' })
    #
    class EmbeddedValue < Attribute
      primitive ::OpenStruct

      # @api public
      def coerce(input)
        if input.kind_of?(primitive)
          input
        elsif input.kind_of?(::Hash)
          primitive.new(input)
        else
          input
        end
      end

      # @api public
      def primitive
        @options[:primitive]
      end

    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
