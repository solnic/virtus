module Virtus
  class Attribute

    # Abstract superclass for collection Attributes.
    #
    # Handles coercing members to the designated member type.
    #
    # @abstract
    class Collection < Attribute

      # Handles collection with member_type syntax
      #
      # @param [Class] type
      #
      # @param [Hash] options
      #
      # @return [Hash]
      #
      # @api private
      def self.merge_options(type, _options)
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
