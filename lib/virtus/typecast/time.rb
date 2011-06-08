module Virtus
  module Typecast
    class Time
      SEGMENTS = [ :year, :month, :day, :hour, :min, :sec ].freeze

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
          if value.respond_to?(:to_time)
            value.to_time
          elsif value.is_a?(::Hash)
            hash_to_time(value)
          else
            ::Time.parse(value.to_s)
          end
        rescue ArgumentError
          value
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
          if value.respond_to?(:to_date)
            value.to_date
          elsif value.is_a?(::Hash)
            hash_to_date(value)
          else
            ::Date.parse(value.to_s)
          end
        rescue ArgumentError
          value
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
        def to_date_time(value)
          if value.is_a?(::Hash)
            hash_to_datetime(value)
          else
            ::DateTime.parse(value.to_s)
          end
        rescue ArgumentError
          value
        end

        private

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
