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
      # @param [Class] type
      #
      # @param [Hash] options
      #
      # @return [Hash]
      #
      # @api private
      def self.merge_options(type, options)
        merged_options = super

        if !type.respond_to?(:count)
          merged_options
        elsif type.count > 1
          raise NotImplementedError, "build SumType from list of types (#{type.inspect})"
        else
          merged_options.merge!(:member_type => type.first)
        end

        merged_options
      end

      # Initialize an instance of {Virtus::Attribute::Collection}
      #
      # @api private
      def initialize(*)
        super
        @member_type          = @options.fetch(:member_type, Object)
        @member_type_instance = Attribute.build(@name, @member_type, :coerce => coerce?)
      end

      # Coerce a collection with members
      #
      # @param [Object] value
      #
      # @return [Object]
      #
      # @api private
      def coerce(value)
        coerced = super
        return coerced unless coerced.respond_to?(:each_with_object)
        coerced.each_with_object(new_collection) do |entry, collection|
          coerce_and_append_member(collection, entry)
        end
      end

      # Return an instance of the collection
      #
      # @return [Enumerable]
      #
      # @api private
      def new_collection
        (@options[:primitive] || self.class.primitive).new
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

    end # class Collection
  end # class Attribute
end # module Virtus
