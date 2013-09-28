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

      class Coercer
        attr_reader :primitive

        def initialize(primitive)
          @primitive = primitive
        end

      end # Coercer

      class FromStruct < Coercer

        # @api public
        def call(input)
          if input.kind_of?(primitive)
            input
          elsif not input.nil?
            primitive.new(*input)
          end
        end

      end # FromStruct

      class FromOpenStruct < Coercer

        # @api public
        def call(input)
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
      def self.build_type(definition)
        klass = definition.primitive.is_a?(Class) ? definition.primitive : definition.type
        Axiom::Types::Object.new { primitive klass }
      end

      # @api private
      def self.build_coercer(type, _options)
        primitive = type.primitive

        if primitive < Virtus || primitive < Model::Constructor || primitive <= OpenStruct
          FromOpenStruct.new(primitive)
        elsif primitive < Struct
          FromStruct.new(primitive)
        end
      end

      # @api public
      def primitive
        type.primitive
      end

    end # class EmbeddedValue

  end # class Attribute
end # module Virtus
