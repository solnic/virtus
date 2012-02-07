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

      # @see Attribute.merge_options
      #
      # @return [Hash]
      #   an updated options hash for configuring an EmbeddedValue instance
      #
      # @api private
      def self.merge_options(type, options)
        options.merge(:model => type)
      end

      # Sets @model ivar
      #
      # @see Virtus::Attribute#initialize
      #
      # @return [undefined]
      #
      # @api private
      def initialize(name, options = {})
        super
        @model = options.fetch(:model, OpenStruct)
      end

      # Coerce attributes into a virtus object
      #
      # @param [Hash,Virtus]
      #
      # @return [Virtus]
      #
      # @api private
      def coerce(attributes_or_object)
        value = if attributes_or_object.kind_of?(::Hash)
                  @model.new(attributes_or_object)
                else
                  attributes_or_object
                end

        super(value)
      end

    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
