module Virtus
  class Attribute

    # DateTime
    #
    # @example
    #   class Post
    #     include Virtus
    #
    #     attribute :published_at, DateTime
    #   end
    #
    #   Post.new(:published_at => DateTime.now)
    #
    #   # typecasting from a string
    #   Post.new(:published_on => '2011/06/09 10:48')
    #
    #   # typecasting from a hash
    #   Post.new(:published_on => {
    #     :year => 2011, :month => 6, :day => 9, :hour => 10, :minutes => 48 })
    #
    #   # typecasting from an object which implements #to_datetime
    #   Post.new(:published_on => Time.now)
    #
    class DateTime < Object
      primitive ::DateTime

      # @see Virtus::Typecast::Time.to_datetime
      #
      # @return [DateTime]
      #
      # @api private
      def typecast_to_primitive(value)
        Typecast::Time.to_datetime(value)
      end

    end # class DateTim
  end # class Attribute
end # module Virtus
