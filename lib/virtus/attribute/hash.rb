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
    class Hash < Object
      primitive       ::Hash
      coercion_method :to_hash
      default         primitive.new

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

      # Handles hashes with [key_type => value_type] syntax.
      #
      # @param [Class] type
      #
      # @param [Hash] options
      #
      # @return [Hash]
      #
      # @api private
      def self.merge_options(type, options)
        if !type.respond_to?(:size)
          options
        elsif type.size > 1
          raise ArgumentError, "more than one [key => value] pair in `#{type.inspect}`"
        else
          key_type, value_type = type.first
          options.merge(:key_type => key_type, :value_type => value_type)
        end
      end

      # Initialize an instance of {Virtus::Attribute::Hash}
      #
      # @api private
      def initialize(*)
        super
        @key_type            = @options.fetch(:key_type,   Object)
        @value_type          = @options.fetch(:value_type, Object)
        @key_type_instance   = Attribute.build(@name, @key_type)
        @value_type_instance = Attribute.build(@name, @value_type)
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
        self.class.primitive.new
      end

    end # class Hash
  end # class Attribute
end # module Virtus
