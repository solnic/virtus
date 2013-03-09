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
      def self.merge_options(type, _options)
        super.update(:primitive => type)
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
        if klass <= Virtus || klass <= OpenStruct || klass <= Struct
          self
        end
      end

      # @api private
      def self.coercer(type, _options = {})
        if type <= Virtus || type <= OpenStruct
          OpenStructCoercer.new(type)
        elsif type <= Struct
          StructCoercer.new(type)
        else
          super
        end
      end

    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
