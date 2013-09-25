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
      TYPES = [Struct, OpenStruct, Virtus, Model::Constructor].freeze

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

      # @api private
      def self.handles?(klass)
        klass.is_a?(Class) && TYPES.any? { |type| klass <= type }
      end

      # @api private
      def self.determine_type(klass)
        if klass < Virtus || klass < Model::Constructor || klass <= OpenStruct
          FromOpenStruct
        elsif klass < Struct
          FromStruct
        end
      end

      # @api private
      def self.build_type(options)
        Axiom::Types::Object.new { primitive options[:type] }
      end

      # @api public
      def primitive
        type.primitive
      end

    end # class EmbeddedValue
  end # class Attribute
end # module Virtus
