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
      default         primitive.new

      # Handles hashes with [key_type => value_type] syntax.
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

        if !type.respond_to?(:size)
          merged_options
        elsif type.size > 1
          raise ArgumentError, "more than one [key => value] pair in `#{type.inspect}`"
        else
          key_type, value_type = type.first
          merged_options.merge!(:key_type => key_type, :value_type => value_type)
        end

        merged_options
      end

      # @api private
      def self.coercible_writer_class(type, options)
        options[:key_type] && options[:value_type] ? CoercibleWriter : super
      end

      # @api private
      def self.writer_option_names
        super.concat([ :key_type, :value_type ])
      end

    end # class Hash
  end # class Attribute
end # module Virtus
