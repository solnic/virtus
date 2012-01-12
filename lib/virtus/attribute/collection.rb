module Virtus
  class Attribute

    # Abstract superclass for collection Attributes.
    #
    # Handles coercing members to the designated member type.
    #
    # @abstract
    class Collection < Object

      attr_reader :member_type

      def self.merge_options(type, options)
        if type.size > 1
          raise NotImplementedError, "build SumType from list of types (#{type.inspect})"
        else
          options.merge(:member_type => type.first || Virtus::Attribute::Object)
        end
      end

      def initialize(*)
        super
        @member_type = @options.fetch(:member_type)
        @member_type_instance = Attribute.build(@name, @member_type)
      end

      def coerce(value)
        coerced = super

        if coerced.respond_to?(:map)
          coerced.map { |val| @member_type_instance.coerce(val) }
        else
          coerced
        end
      end

    end # class Array
  end # class Attribute
end # module Virtus
