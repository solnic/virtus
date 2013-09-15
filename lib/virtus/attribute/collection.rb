module Virtus
  class Attribute

    # Abstract superclass for collection Attributes.
    #
    # Handles coercing members to the designated member type.
    #
    # @abstract
    class Collection < Attribute
      default Proc.new { |_, attribute| attribute.type.primitive.new }

      Type = Struct.new(:primitive, :member_type) do
        def coercion_method
          :to_array
        end
      end

      # @api private
      def self.determine_type(primitive)
        if primitive < Enumerable
          self
        end
      end

      def self.build_type(primitive, options)
        type_options = infer_options(primitive)

        klass  = Axiom::Types.infer(primitive)
        member = type_options.fetch(:member_type, Axiom::Types::Object)

        # FIXME: temporary hack, remove when Axiom::Type works with EV as member_type
        if EmbeddedValue.determine_type(member)
          Type.new(self.primitive || klass.primitive, member)
        else
          klass.new { member_type Axiom::Types.infer(member) }
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
          options.merge!(:member_type => type.first)
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

      # @api public
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
