module Virtus
  class Attribute
    class Hash

      class CoercibleWriter < Attribute::Writer::Coercible

        # @api private
        def initialize(name, visibility, options)
          super
          @key_type            = options.fetch(:key_type,   Object)
          @value_type          = options.fetch(:value_type, Object)
          @key_type_instance   = Attribute.build(@name, @key_type,   :coerce => true)
          @value_type_instance = Attribute.build(@name, @value_type, :coerce => true)
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
            hash[@key_type_instance.coerce(key)] = @value_type_instance.coerce(value)
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
