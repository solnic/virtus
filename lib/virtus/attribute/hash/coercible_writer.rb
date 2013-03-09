module Virtus
  class Attribute
    class Hash

      # Coercible writer for Hash attributes
      #
      class CoercibleWriter < Attribute::Writer::Coercible

        # The type to which keys of this hash will be coerced
        #
        # @return [Virtus::Attribute]
        #
        # @api private
        attr_reader :key_type

        # The type to which values of this hash will be coerced
        #
        # @return [Virtus::Attribute]
        #
        # @api private
        attr_reader :value_type

        # Return writer for hash keys
        #
        # @return [Writer::Coercible]
        #
        # @api private
        attr_reader :key_coercer

        # Return writer for hash values
        #
        # @return [Writer::Coercible]
        #
        # @api private
        attr_reader :value_coercer

        # @api private
        def initialize(name, options)
          super
          @key_type      = options.fetch(:key_type,   ::Object)
          @value_type    = options.fetch(:value_type, ::Object)
          @key_coercer   = Attribute.determine_type(@key_type).coercer(@key_type)
          @value_coercer = Attribute.determine_type(@value_type).coercer(@value_type)
        end

        # Coerce a hash with keys and values
        #
        # @param [Object] value
        #
        # @return [Object]
        #
        # @api private
        def coerce(input)
          coerced = super
          return coerced unless coerced.respond_to?(:each_with_object)
          coerced.each_with_object(new_hash) do |(key, value), hash|
            hash[key_coercer.call(key)] = value_coercer.call(value)
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
