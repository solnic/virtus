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
      # @param [Class]
      #
      # @param [Hash]
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
          options.merge(:key_type => type.keys.first, :value_type => type.values.first)
        end
      end

      # Initializes an instance of {Virtus::Attribute::Hash}
      #
      # @api private
      def initialize(*)
        super
        @key_type   = @options[:key_type] || Object
        @value_type = @options[:value_type] || Object
        @key_type_instance   = Attribute.build(@name, @key_type)
        @value_type_instance = Attribute.build(@name, @value_type)
      end

      # Coerce a hash with keys and values
      #
      # @param [Object]
      #
      # @return [Object]
      #
      # @api private
      def coerce(value)
        coerced = super
        return coerced unless coerced.respond_to?(:each_with_object)
        coerced.each_with_object({}) do |(key, value), hash|
          hash[@key_type_instance.coerce(key)] = @value_type_instance.coerce(value)
        end
      end

    end # class Hash
  end # class Attribute
end # module Virtus
