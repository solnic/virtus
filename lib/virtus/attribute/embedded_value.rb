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
      primitive ::OpenStruct

      # @see Attribute.merge_options
      #
      # @return [Hash]
      #   an updated options hash for configuring an EmbeddedValue instance
      #
      # @api private
      def self.merge_options(type, options)
        options.merge(:primitive => type)
      end

      # Determine type based on class
      #
      # Virtus::EmbeddedValue.determine_type(Struct) # => Virtus::EmbeddedValue::FromStruct
      # Virtus::EmbeddedValue.determine_type(VirtusClass) # => Virtus::EmbeddedValue::FromOpenStruct
      #
      # @param [Class] klass
      #
      # @return [Virtus::Attribute::EmbeddedValue]
      #
      # @api private
      def self.determine_type(klass)
        if klass <= Virtus || klass <= OpenStruct
          FromOpenStruct
        elsif klass <= Struct
          FromStruct
        end
      end

      # Coerce attributes into a virtus object
      #
      # @param [Hash,Virtus]
      #
      # @return [Virtus]
      #
      # @api private
      def coerce(value)
        value if value.kind_of?(@primitive)
      end

    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
