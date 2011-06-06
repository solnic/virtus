module Virtus
  module Attributes
    module Typecast
      module Time
        include Numeric

        SEGMENTS = [ :year, :month, :day, :hour, :min, :sec ].freeze

        # Extracts the given args from the hash. If a value does not exist, it
        # uses the value of Time.now.
        #
        # @param [Hash, #to_mash] value
        #   value to extract time args from
        #
        # @return [Array]
        #   Extracted values
        #
        # @api private
        def extract_time(value)
          now  = ::Time.now

          SEGMENTS.map do |segment|
            typecast_to_numeric(value.fetch(segment, now.send(segment)), :to_i)
          end
        end
      end # Time
    end # Typecast
  end # Attributes
end # Virtus
