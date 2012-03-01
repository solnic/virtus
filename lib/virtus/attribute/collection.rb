module Virtus
  class Attribute

    # Abstract superclass for collection Attributes.
    #
    # Handles coercing members to the designated member type.
    #
    # @abstract
    class Collection < Object

      # The type to which members of this collection will be coerced
      #
      # @example
      #
      #   class Post
      #     include Virtus
      #
      #     attribute :tags, Array[String]
      #   end
      #
      #   Post.attributes[:tags].member_type # => Virtus::Attribute::String
      #
      # @return [Virtus::Attribute]
      #
      # @api public
      attr_reader :member_type

      # Handles collection with member_type syntax
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
          raise NotImplementedError, "build SumType from list of types (#{type.inspect})"
        else
          options.merge(:member_type => type.first)
        end
      end

      # Init an instance of Virtus::Attribute::Collection
      #
      # @api private
      def initialize(*)
        super
        @member_type = @options.fetch(:member_type, Virtus::Attribute::Object)
        @member_type_instance = Attribute.build(@name, @member_type)
      end

      # Coerce a collection with members
      #
      # @param [Object]
      #
      # @return [Object]
      #
      # @api private
      def coerce(value)
        coerced = super
        return coerced unless coerced.respond_to?(:inject)
        coerced.inject(new_collection) do |*args|
          coerce_and_append_member(*args)
        end
      end

      # Return an instance of the collection
      #
      # @return [Enumerable]
      #
      # @api private
      def new_collection
        self.class.primitive.new
      end

      # Coerce entry and add it to the collection
      #
      # @abstract
      #
      # @raise NotImplementedError
      #
      # @return [undefined]
      #
      # @api private
      def coerce_and_append_member(collection, entry)
        raise NotImplementedError,
          "#{self.class}#coerce_and_append_member has not been implemented"
      end

      # Default coercion method for collection members used by Array and Set
      module MemberCoercion

        # Coerce a member of a source collection and append it to the target collection
        #
        # @param [Array, Set] collection
        #   target collection to which the coerced member should be appended
        #
        # @param [Object] entry
        #   the member that should be coerced and appended
        #
        # @return [Array, Set]
        #   collection with the coerced member appended to it
        #
        # @api private
        def coerce_and_append_member(collection, entry)
          collection << @member_type_instance.coerce(entry)
        end
      end # module MemberCoercion

    end # class Array
  end # class Attribute
end # module Virtus
