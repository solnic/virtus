module Virtus
  module Typecast

    # Date
    #
    class Date

      # @api public
      def self.to_datetime(value)
        if value.respond_to?(:to_datetime)
          value.to_datetime
        else
          String.to_datetime(value.to_s)
        end
      end

      # @api public
      def self.to_time(value)
        value.to_time
      end

    end # class Date
  end # module Typecast
end # module Virtus
