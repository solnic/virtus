module Virtus
  class Attribute

    # EmbeddedValue handles virtus-like objects, OpenStruct and Struct
    #
    class EmbeddedValue < Attribute
      TYPES = [Struct, OpenStruct, Virtus, Model::Constructor].freeze

      # Builds Struct-like instance with attributes passed to the constructor as
      # a list of args rather than a hash
      #
      # @private
      class FromStruct < Virtus::Coercer

        # @api public
        def call(input)
          if input.kind_of?(primitive)
            input
          elsif not input.nil?
            primitive.new(*input)
          end
        end

      end # FromStruct

      # Builds OpenStruct-like instance with attributes passed to the constructor
      # as a hash
      #
      # @private
      class FromOpenStruct < Virtus::Coercer

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
        Axiom::Types::Object.new { primitive definition.primitive }
      end

      # @api private
      def self.build_coercer(type, _options)
        primitive = type.primitive

        if primitive < Virtus || primitive < Model::Constructor || primitive <= OpenStruct
          FromOpenStruct.new(type)
        elsif primitive < Struct
          FromStruct.new(type)
        end
      end

    end # class EmbeddedValue

  end # class Attribute
end # module Virtus
