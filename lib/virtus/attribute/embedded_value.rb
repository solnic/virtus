require 'ostruct'

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
    class EmbeddedValue < Object

      # @api private
      def initialize(name, options = {})
        super
        @model = options.fetch(:model, OpenStruct)
      end

      # Set an embedded instance
      #
      # @see Virtus::Attribute#set
      #
      # @api public
      def set(instance, attributes_or_object)
        value = if attributes_or_object.kind_of?(::Hash)
                  @model.new(attributes_or_object)
                else
                  attributes_or_object
                end

        super(instance, value)
      end

    end # class Array
  end # class Attribute
end # module Virtus
