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

    private

      # @api private
      def self.call(value, method)
        return value.send(method) if value.respond_to?(method)

        begin
          if value.kind_of?(::Hash)
            from_hash(value, method)
          else
            from_string(value.to_s, method)
          end
        rescue ArgumentError
          return value
        end
      end

      # @api private
      def self.from_string(value, method)
        METHOD_TO_CLASS[method].parse(value.to_s)
      end

      # @api private
      def self.from_hash(value, method)
        send("hash_#{method}", value)
      end

      # Creates a Time instance from a Hash
      #
      # Valid keys are: :year, :month, :day, :hour, :min, :sec
      #
      # @param [Hash, #to_mash] value
      #   value to be typecast
      #
      # @return [Time]
      #   Time constructed from hash
      #
      # @api private
      def self.hash_to_time(value)
        ::Time.local(*extract(value))
      end

      # Creates a Date instance from a Hash
      #
      # Valid keys are: :year, :month, :day, :hour
      #
      # @param [Hash, #to_mash] value
      #   value to be typecast
      #
      # @return [Date]
      #   Date constructed from hash
      #
      # @api private
      def self.hash_to_date(value)
        ::Date.new(*extract(value).first(3))
      end

      # Creates a DateTime instance from a Hash
      #
      # Valid keys are: :year, :month, :day, :hour, :min, :sec
      #
      # @param [Hash, #to_mash] value
      #   value to be typecast
      #
      # @return [DateTime]
      #   DateTime constructed from hash
      #
      # @api private
      def self.hash_to_datetime(value)
        ::DateTime.new(*extract(value))
      end

      # Extracts the given args from the hash
      #
      # If a value does not exist, it uses the value of Time.now
      #
      # @param [Hash, #to_mash] value
      #   value to extract time args from
      #
      # @return [Array]
      #   Extracted values
      #
      # @api private
      def self.extract(value)
        now = ::Time.now

        SEGMENTS.map do |segment|
          Numeric.to_i(value.fetch(segment, now.send(segment)))
        end
      end

    end # class Time
  end # module Typecast
end # module Virtus
