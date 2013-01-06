module Virtus
  class Attribute
    class Hash

      class CoercibleWriter < Attribute::Writer::Coercible

        # The type to which keys of this hash will be coerced
        #
        # @example
        #
        #   class Request
        #     include Virtus
        #
        #     attribute :headers, Hash[Symbol => String]
        #   end
        #
        #   Post.attributes[:headers].key_type # => Virtus::Attribute::Symbol
        #
        # @return [Virtus::Attribute]
        #
        # @api public
        attr_reader :key_type

        # The type to which values of this hash will be coerced
        #
        # @example
        #
        #   class Request
        #     include Virtus
        #
        #     attribute :headers, Hash[Symbol => String]
        #   end
        #
        #   Post.attributes[:headers].value_type # => Virtus::Attribute::String
        #
        # @return [Virtus::Attribute]
        #
        # @api public
        attr_reader :value_type

        attr_reader :key_writer

        attr_reader :value_writer

        # @api private
        def initialize(name, visibility, options)
          super
          @key_type     = options.fetch(:key_type,   Object)
          @value_type   = options.fetch(:value_type, Object)
          @key_writer   = Attribute.build(@name, @key_type,   :coerce => true).writer
          @value_writer = Attribute.build(@name, @value_type, :coerce => true).writer
        end

        # Coerce a hash with keys and values
        #
        # @param [Object] value
        #
        # @return [Object]
        #
        # @api private
        def coerce(value)
          coerced = super
          return coerced unless coerced.respond_to?(:each_with_object)
          coerced.each_with_object(new_hash) do |(key, value), hash|
            hash[key_writer.coerce(key)] = value_writer.coerce(value)
          end
        end

        private

        # Return an instance of the hash
        #
        # @return [Hash]
        #
        # @api private
        def new_hash
          primitive.new
        end

      end # class CoercibleWriter

    end # class Collection
  end # class Attribute
end # module Virtus
