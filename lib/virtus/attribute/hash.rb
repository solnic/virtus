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
        if @options.has_key?(:key_type) && @options.has_key?(:value_type)
          @key_type   = @options[:key_type]
          @value_type = @options[:value_type]
          @key_type_instance   = Attribute.build(@name, @key_type)
          @value_type_instance = Attribute.build(@name, @value_type)
        end
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
        return coerced unless coerced.respond_to?(:inject)
        coerced.inject(new_hash) do |hash, key_and_value|
          hash[key_and_value[0]] = key_and_value[1]
          hash
        end
      end

      # Return an instance of the Hash with redefined []= method to coerce
      # keys and values on assigning.
      #
      # @return [Hash]
      #
      # @api private
      def new_hash
        hash = self.class.primitive.new
        return hash unless @key_type_instance && @value_type_instance

        key_coercion_method   = @key_type_instance.coercion_method
        value_coercion_method = @value_type_instance.coercion_method

        # Redefine []= method to coerce key and value on assigning.
        # It requires inlining of Attribute#coerce method to coerce.
        # An alternative way would be using define_singleton_method or Sinatra's meta_def.
        hash.instance_eval(<<-eorb, __FILE__, __LINE__+1)
          def []=(key, value)                                                              #  def []=(key, value)
            coerced_key   = Virtus::Coercion[key.class].#{key_coercion_method}(key)        #    coerced_key   = Virtus::Coercion[key.class].to_sym(key)
            coerced_value = Virtus::Coercion[value.class].#{value_coercion_method}(value)  #    coerced_value = Virtus::Coercion[value.class].to_f(value)
            super(coerced_key, coerced_value)                                              #    super(coerced_key, coerced_value)
          end                                                                              #  end
        eorb

        hash
      end

    end # class Hash
  end # class Attribute
end # module Virtus
