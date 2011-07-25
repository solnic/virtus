module Virtus
  class Attribute

    # Date
    #
    # @example
    #   class Post
    #     include Virtus
    #
    #     attribute :published_on, Date
    #   end
    #
    #   Post.new(:published_on => Date.today)
    #
    #   # typecasting from a string
    #   Post.new(:published_on => '2011/06/09')
    #
    #   # typecasting from a hash
    #   Post.new(:published_on => {
    #     :year  => 2011,
    #     :month => 6,
    #     :day   => 9,
    #   })
    #
    #   # typecasting from an object which implements #to_date
    #   Post.new(:published_on => DateTime.now)
    #
    class Date < Object
      primitive       ::Date
      coercion_method :to_date

    end # class Date
  end # class Attribute
end # module Virtus
