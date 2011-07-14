module Virtus
  module Typecast

    # DateTime
    #
    class DateTime < Object

      # @api public
      def self.to_date(value)
        if value.respond_to?(:to_date)
          value.to_date
        else
          String.to_date(value.to_s)
        end
      end

      # @api public
      def self.to_time(value)
        if value.respond_to?(:to_time)
          value.to_time
        else
          String.to_time(value.to_s)
        end
      end

    end # class DateTime
  end # module Typecast
end # module Virtus
