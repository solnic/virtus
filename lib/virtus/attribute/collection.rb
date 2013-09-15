module Virtus
  class Attribute

    # Abstract superclass for collection Attributes.
    #
    # Handles coercing members to the designated member type.
    #
    # @abstract
    class Collection < Attribute
      default Proc.new { |_, attribute| attribute.type.primitive.new }

      # @api private
      def self.determine_type(primitive)
        if primitive == Array || primitive == Set
          self
        end
      end

      def self.build_type(primitive, options)
        type_options = infer_options(primitive)

        Axiom::Types.infer(primitive).new do
          member_type type_options.fetch(:member_type, Axiom::Types::Object)
        end
      end

      # Handles collection with member_type syntax
      #
      # @param [Class] type
      #
      # @param [Hash] options
      #
      # @return [Hash]
      #
      # @api private
      def self.infer_options(type)
        options = {}

        if !type.respond_to?(:count)
          options
        elsif type.count > 1
          raise NotImplementedError, "build SumType from list of types (#{type.inspect})"
        else
          options.merge!(:member_type => Axiom::Types.infer(type.first))
        end

        options
      end

      # @api private
      def self.merge_options!(type, options)
        super

        unless options.key?(:member_type)
          options[:member_type] = Attribute.build(type.member_type)
        end
      end

      def coerce(input)
        coerced = super

        return coerced unless coerced.respond_to?(:each_with_object)

        coerced.each_with_object(new_collection) do |entry, collection|
          collection << member_type.coerce(entry)
        end
      end

      def new_collection
        type.primitive.new
      end

      def member_type
        @options[:member_type]
      end

    end # class Collection
  end # class Attribute
end # module Virtus
