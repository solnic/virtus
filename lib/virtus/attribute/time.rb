module Virtus
  class Attribute

    # Example usage:
    #
    #   class Post
    #     include Virtus
    #
    #     attribute :published_at, Time
    #   end
    #
    #   Post.new(:published_at => Time.now)
    #
    #   # typecasting from a string
    #   Post.new(:published_at => '2011/06/09 11:08')
    #
    #   # typecasting from a hash
    #   Post.new(:published_at => {
    #     :year    => 2011,
    #     :month   => 6,
    #     :day     => 9,
    #     :hour    => 11,
    #     :minutes => 8
    #   })
    #
    #   # typecasting from an object which implements #to_time
    #   Post.new(:published_at => DateTime.now)
    #
    class Time < Object
      primitive ::Time

      # @see Virtus::Typecast::Time.to_time
      #
      # @return [Time]
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Time.to_time(value)
      end

    end # class Time
  end # class Attribute
end # module Virtus
