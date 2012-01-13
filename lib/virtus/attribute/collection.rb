module Virtus
  class Attribute

    # Abstract superclass for collection Attributes.
    #
    # Handles coercing members to the designated member type.
    #
    # @abstract
    class Collection < Object

      # The type to which members of this collection will be coerced
      # @return [Virtus::Attribute]
      attr_reader :member_type

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
      def initialize(*)
        super
        @member_type = @options.fetch(:member_type, Virtus::Attribute::Object)
        @member_type_instance = Attribute.build(@name, @member_type)
      end

      def coerce(value)
        coerced = super
        return coerced unless coerced.respond_to?(:inject)
        coerced.inject(new_collection) do |collection, entry|
          coerce_and_append_member(collection, entry)
        end
      end

      def new_collection
        self.class.primitive.new
      end

      def coerce_and_append_member(collection, entry)
        raise NotImplementedError,
          "#{self.class}#coerce_and_append_member has not been implemented"
      end

    end # class Array
  end # class Attribute
end # module Virtus
