module Virtus
  class Attribute

    # Time
    #
    # @example
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
    #     :year  => 2011,
    #     :month => 6,
    #     :day   => 9,
    #     :hour  => 11,
    #     :min   => 8,
    #   })
    #
    #   # typecasting from an object which implements #to_time
    #   Post.new(:published_at => DateTime.now)
    #
    class Time < Object
      primitive       ::Time
      coercion_method :to_time

    end # class Time
  end # class Attribute
end # module Virtus
