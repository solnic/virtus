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

      class << self
        # Typecasts an arbitrary value to a Time
        # Handles both Hashes and Time instances.
        #
        # @param [Hash, #to_mash, #to_s] value
        #   value to be typecast
        #
        # @return [Time]
        #   Time constructed from value
        #
        # @api public
        def to_time(value)
          call(value, :to_time)
        end

        # Typecasts an arbitrary value to a Date
        # Handles both Hashes and Date instances.
        #
        # @param [Hash, #to_mash, #to_s] value
        #   value to be typecast
        #
        # @return [Date]
        #   Date constructed from value
        #
        # @api public
        def to_date(value)
          call(value, :to_date)
        end

        # Typecasts an arbitrary value to a DateTime.
        # Handles both Hashes and DateTime instances.
        #
        # @param [Hash, #to_mash, #to_s] value
        #   value to be typecast
        #
        # @return [DateTime]
        #   DateTime constructed from value
        #
        # @api public
        def to_datetime(value)
          call(value, :to_datetime)
        end

        private

        # @api private
        def call(value, method)
          return value.send(method) if value.respond_to?(method)

          begin
            if value.is_a?(::Hash)
              from_hash(value, method)
            else
              from_string(value.to_s, method)
            end
          rescue ArgumentError
            return value
          end
        end

        # @api private
        def from_string(value, method)
          METHOD_TO_CLASS[method].parse(value.to_s)
        end

        # @api private
        def from_hash(value, method)
          send("hash_#{method}", value)
        end

        # Creates a Time instance from a Hash with keys :year, :month, :day,
        # :hour, :min, :sec
        #
        # @param [Hash, #to_mash] value
        #   value to be typecast
        #
        # @return [Time]
        #   Time constructed from hash
        #
        # @api private
        def hash_to_time(value)
          ::Time.local(*extract(value))
        end

        # Creates a Date instance from a Hash with keys :year, :month, :day
        #
        # @param [Hash, #to_mash] value
        #   value to be typecast
        #
        # @return [Date]
        #   Date constructed from hash
        #
        # @api private
        def hash_to_date(value)
          ::Date.new(*extract(value).first(3))
        end

        # Creates a DateTime instance from a Hash with keys :year, :month, :day,
        # :hour, :min, :sec
        #
        # @param [Hash, #to_mash] value
        #   value to be typecast
        #
        # @return [DateTime]
        #   DateTime constructed from hash
        #
        # @api private
        def hash_to_datetime(value)
          ::DateTime.new(*extract(value))
        end

        # Extracts the given args from the hash. If a value does not exist, it
        # uses the value of Time.now.
        #
        # @param [Hash, #to_mash] value
        #   value to extract time args from
        #
        # @return [Array]
        #   Extracted values
        #
        # @api public
        def extract(value)
          now = ::Time.now

          SEGMENTS.map do |segment|
            Numeric.to_i(value.fetch(segment, now.send(segment)))
          end
        end
      end
    end # Time
  end # Typecast
end # Virtus
