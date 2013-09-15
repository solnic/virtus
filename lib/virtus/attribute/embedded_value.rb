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

      class FromStruct < self

        # @api public
        def coerce(input)
          if input.kind_of?(primitive)
            input
          elsif not input.nil?
            primitive.new(*input)
          end
        end
      end # FromStruct

      class FromOpenStruct < self

        # @api public
        def coerce(input)
          if input.kind_of?(primitive)
            input
          elsif not input.nil?
            primitive.new(input)
          end
        end
      end # FromOpenStruct

      # @api public
      def primitive
        @options[:primitive]
      end

    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
