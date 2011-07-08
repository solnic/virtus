module Virtus
  class Attribute

    # Example usage:
    #
    #   class Post
    #     include Virtus
    #
    #     attribute :read_count, Integer
    #   end
    #
    #   Post.new(:read_count => 100)
    #
    #   # typecasting from a string
    #   Post.new(:read_count => '100')
    #
    #   # typecasting from an object that implements #to_i
    #   Post.new(:read_count => 100.0)
    #
    class Integer < Numeric
      primitive ::Integer

      # @see Virtus::Typecast::Numeric.to_i
      #
      # @return [Integer]
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Numeric.to_i(value)
      end

    end # class Integer
  end # class Attribute
end # module Virtus
