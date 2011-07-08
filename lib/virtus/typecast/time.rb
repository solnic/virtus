module Virtus
  module Typecast

    # Typecast various values into Date, DateTime or Time
    class Time
      SEGMENTS = [ :year, :month, :day, :hour, :min, :sec ].freeze

      METHOD_TO_CLASS = {
        :to_time     => ::Time,
        :to_date     => ::Date,
        :to_datetime => ::DateTime
      }.freeze

      # Typecasts an arbitrary value to a Time
      #
      # Handles both Hashes and Time instances
      #
      # @example
      #   Virtus::Typecast::Time.to_time('2011/06/09 12:01')
      #   # => Thu Jun 09 12:01:00 +0200 2011
      #
      # @param [#to_hash, #to_s] value
      #   value to be typecast
      #
      # @return [Time]
      #   Time constructed from value
      #
      # @api public
      def self.to_time(value)
        call(value, :to_time)
      end

      # Typecasts an arbitrary value to a Date
      #
      # Handles both Hashes and Date instances
      #
      # @example
      #   Virtus::Typecast::Time.to_date('2011/06/09')
      #   # => #<Date: 4911443/2,0,2299161>
      #
      # @param [#to_hash, #to_s] value
      #   value to be typecast
      #
      # @return [Date]
      #   Date constructed from value
      #
      # @api public
      def self.to_date(value)
        call(value, :to_date)
      end

      # Typecasts an arbitrary value to a DateTime
      #
      # Handles both Hashes and DateTime instances
      #
      # @example
      #   Virtus::Typecast::Time.to_datetime('2011/06/09 12:01')
      #   # => #<DateTime: 3536239681/1440,0,2299161>
      #
      # @param [#to_hash, #to_s] value
      #   value to be typecast
      #
      # @return [DateTime]
      #   DateTime constructed from value
      #
      # @api public
      def self.to_datetime(value)
        call(value, :to_datetime)
      end

      # Coerce the value into a Date, Time or DateTime object
      #
      # @param [#to_hash, #to_s] value
      #
      # @param [Symbol] method
      #
      # @return [Object]
      #
      # @api private
      def self.call(value, method)
        return value.send(method) if value.respond_to?(method)

        begin
          if value.respond_to?(:to_hash)
            from_hash(value.to_hash, method)
          else
            from_string(value.to_s, method)
          end
        rescue ArgumentError
          return value
        end
      end

      private_class_method :call

      # Coerce the string into a Date, Time or DateTime object
      #
      # @param [String] value
      #
      # @param [Symbol] method
      #
      # @return [Object]
      #
      # @api private
      def self.from_string(value, method)
        METHOD_TO_CLASS[method].parse(value)
      end

      private_class_method :from_string

      # Coerce the Hash into a Date, Time or DateTime object
      #
      # @param [Hash] value
      #
      # @param [Symbol] method
      #
      # @return [Object]
      #
      # @api private
      def self.from_hash(value, method)
        send("hash_#{method}", value)
      end

      private_class_method :from_hash

      # Creates a Time instance from a Hash
      #
      # Valid keys are: :year, :month, :day, :hour, :min, :sec
      #
      # @param [Hash] value
      #
      # @return [Time]
      #
      # @api private
      def self.hash_to_time(value)
        ::Time.local(*extract(value))
      end

      private_class_method :hash_to_time

      # Creates a Date instance from a Hash
      #
      # Valid keys are: :year, :month, :day, :hour
      #
      # @param [Hash] value
      #
      # @return [Date]
      #
      # @api private
      def self.hash_to_date(value)
        ::Date.new(*extract(value).first(3))
      end

      private_class_method :hash_to_date

      # Creates a DateTime instance from a Hash
      #
      # Valid keys are: :year, :month, :day, :hour, :min, :sec
      #
      # @param [Hash] value
      #
      # @return [DateTime]
      #
      # @api private
      def self.hash_to_datetime(value)
        ::DateTime.new(*extract(value))
      end

      private_class_method :hash_to_datetime

      # Extracts the given args from a Hash
      #
      # If a value does not exist, it uses the value of Time.now
      #
      # @param [Hash] value
      #
      # @return [Array]
      #
      # @api private
      def self.extract(value)
        now = ::Time.now

        SEGMENTS.map do |segment|
          Numeric.to_i(value.fetch(segment, now.send(segment)))
        end
      end

      private_class_method :extract

    end # class Time
  end # module Typecast
end # module Virtus
