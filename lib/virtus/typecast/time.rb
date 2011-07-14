module Virtus
  module Typecast

    # Time
    #
    class Time < Object

      # @api public
      def self.to_datetime(value)
        if value.respond_to?(:to_datetime)
          value.to_datetime
        else
          String.to_datetime(value.to_s)
        end
      end

      # @api public
      def self.to_date(value)
        if value.respond_to?(:to_date)
          value.to_date
        else
          String.to_date(value.to_s)
        end
      end

    end # class Time
  end # module Typecast
end # module Virtus
