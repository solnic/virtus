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

      # FIXME: remove this once axiom-types supports it
      Type = Struct.new(:key_type, :value_type) do
        def self.infer(type)
          type_options = infer_key_and_value_types(type)
          key_class    = determine_type(type_options.fetch(:key_type,   Object))
          value_class  = determine_type(type_options.fetch(:value_type, Object))

          new(key_class, value_class)
        end

        def self.determine_type(type)
          if EmbeddedValue.determine_type(type)
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
      def self.build_type(options)
        Type.infer(options[:type])
      end

      # @api private
      def self.merge_options!(type, options)
        unless options.key?(:key_type)
          options[:key_type] = Attribute.build(type.key_type)
        end

        unless options.key?(:value_type)
          options[:value_type] = Attribute.build(type.value_type)
        end
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
      def key_type
        @options[:key_type]
      end

      # @api private
      def value_type
        @options[:value_type]
      end

    end # class Hash
  end # class Attribute
end # module Virtus
