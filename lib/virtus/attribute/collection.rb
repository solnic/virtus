module Virtus
  class Attribute

    # Abstract superclass for collection Attributes.
    #
    # Handles coercing members to the designated member type.
    #
    # @abstract
    class Collection < Attribute

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

      # @see Virtus::Attribute.coercible_writer_class
      #
      # @return [::Class]
      #
      # @api private
      def self.coercible_writer_class(_type, options)
        options[:member_type] ? CoercibleWriter : super
      end

      # @see Virtus::Attribute.writer_option_names
      #
      # @return [Array<Symbol>]
      #
      # @api private
      def self.writer_option_names
        super << :member_type
      end

    end # class Collection
  end # class Attribute
end # module Virtus
