module Virtus
  class Attribute

    # Hash
    #
    # @example
    #   class Post
    #     include Virtus
    #
    #     attribute :meta, Hash
    #   end
    #
    #   Post.new(:meta => { :tags => %w(foo bar) })
    #
    class Hash < Attribute
      primitive ::Hash
      default   primitive.new

      attr_reader :key_type
      attr_reader :value_type

      # FIXME: remove this once axiom-types supports it
      Type = Struct.new(:key_type, :value_type) do
        def self.infer(type)
          if axiom_type?(type)
            new(type.key_type, type.value_type)
          else
            type_options = infer_key_and_value_types(type)
            key_class    = determine_type(type_options.fetch(:key_type,   Object))
            value_class  = determine_type(type_options.fetch(:value_type, Object))

            new(key_class, value_class)
          end
        end

        def self.pending?(primitive)
          primitive.is_a?(String) || primitive.is_a?(Symbol)
        end

        def self.axiom_type?(type)
          type.is_a?(Class) && type < Axiom::Types::Type
        end

        def self.determine_type(type)
          return type if pending?(type)

          if EmbeddedValue.handles?(type)
            type
          else
            Axiom::Types.infer(type)
          end
        end

        def self.infer_key_and_value_types(type)
          return {} unless type.kind_of?(::Hash)

          if type.size > 1
            raise ArgumentError, "more than one [key => value] pair in `#{type}`"
          else
            { :key_type => type.keys.first, :value_type => type.values.first }
          end
        end

        def coercion_method
          :to_hash
        end

        def primitive
          ::Hash
        end
      end

      # @api private
      def self.build_type(definition)
        Type.infer(definition.type)
      end

      # @api private
      def self.merge_options!(type, options)
        options[:key_type]   ||= Attribute.build(type.key_type)
        options[:value_type] ||= Attribute.build(type.value_type)
      end

      # @api public
      def coerce(*)
        coerced = super

        return coerced unless coerced.respond_to?(:each_with_object)

        coerced.each_with_object({}) do |(key, value), hash|
          hash[key_type.coerce(key)] = value_type.coerce(value)
        end
      end

      # @api private
      def finalize
        return self if finalized?
        @key_type   = options[:key_type].finalize
        @value_type = options[:value_type].finalize
        super
      end

      # @api private
      def finalized?
        super && key_type.finalized? && value_type.finalized?
      end

    end # class Hash
  end # class Attribute
end # module Virtus
