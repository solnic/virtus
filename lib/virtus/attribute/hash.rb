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
    class Hash < Attribute
      primitive ::Hash
      default   primitive.new

      # @api private
      def self.build_type(primitive, options)
        type_options = infer_options(primitive)

        Axiom::Types.infer(primitive).new do
          key_type   type_options.fetch(:key_type,   Axiom::Types::Object)
          value_type type_options.fetch(:value_type, Axiom::Types::Object)
        end
      end

      # Handles hashes with [key_type => value_type] syntax
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

        if !type.respond_to?(:size)
          options
        elsif type.size > 1
          raise ArgumentError, "more than one [key => value] pair in `#{type.inspect}`"
        else
          key_type, value_type = type.first

          options.merge!(
            :key_type   => Axiom::Types.infer(key_type),
            :value_type => Axiom::Types.infer(value_type)
          )
        end

        options
      end

    end # class Hash
  end # class Attribute
end # module Virtus
