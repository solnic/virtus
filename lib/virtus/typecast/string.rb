module Virtus
  module Typecast

    # Typecast String values
    class String < Object
      TRUE_VALUES  = %w[ 1 t true  ].freeze
      FALSE_VALUES = %w[ 0 f false ].freeze
      BOOLEAN_MAP  = ::Hash[ TRUE_VALUES.product([ true ]) + FALSE_VALUES.product([ false ]) ].freeze

      NUMERIC_REGEXP = /\A(-?(?:0|[1-9]\d*)(?:\.\d+)?|(?:\.\d+))\z/.freeze

      # Typecast given value to Time
      #
      # @example
      #   Virtus::Typecast::String.to_time(string)  # => Time object
      #
      # @param [String] value
      #
      # @return [Time]
      #
      # @api public
      def self.to_time(value)
        parse_value(::Time, value)
      end

      # Typecast given value to Date
      #
      # @example
      #   Virtus::Typecast::String.to_date(string)  # => Date object
      #
      # @param [String] value
      #
      # @return [Date]
      #
      # @api public
      def self.to_date(value)
        parse_value(::Date, value)
      end

      # Typecast given value to DateTime
      #
      # @example
      #   Virtus::Typecast::String.to_datetime(string)  # => DateTime object
      #
      # @param [String] value
      #
      # @return [DateTime]
      #
      # @api public
      def self.to_datetime(value)
        parse_value(::DateTime, value)
      end

      # Typecast value to TrueClass or FalseClass
      #
      # @example with "T"
      #   Virtus::Typecast::String.to_boolean('T')  # => true
      #
      # @example with "F"
      #   Virtus::Typecast::String.to_boolean('F')  # => false
      #
      # @param [#to_s]
      #
      # @return [Boolean]
      #
      # @api public
      def self.to_boolean(value)
        BOOLEAN_MAP.fetch(value.downcase, value)
      end

      # Typecast value to integer
      #
      # @example
      #   Virtus::Typecast::String.to_integer('1')  # => 1
      #
      # @param [Object] value
      #
      # @return [Integer]
      #
      # @api public
      def self.to_integer(value)
        to_numeric(value, :to_i)
      end

      # Typecast value to float
      #
      # @example
      #   Virtus::Typecast::String.to_float('1.2')  # => 1.2
      #
      # @param [Object] value
      #
      # @return [Float]
      #
      # @api public
      def self.to_float(value)
        to_numeric(value, :to_f)
      end

      # Typecast value to decimal
      #
      # @example
      #   Virtus::Typecast::String.to_decimal('1.2')  # => #<BigDecimal:b72157d4,'0.12E1',8(8)>
      #
      # @param [Object] value
      #
      # @return [BigDecimal]
      #
      # @api public
      def self.to_decimal(value)
        to_numeric(value, :to_d)
      end

      # Match numeric string
      #
      # @param [String] value
      #   value to typecast
      # @param [Symbol] method
      #   method to typecast with
      #
      # @return [Numeric]
      #   number if matched, value if no match
      #
      # @api private
      def self.to_numeric(value, method)
        if value =~ NUMERIC_REGEXP
          $1.send(method)
        else
          value
        end
      end

      private_class_method :to_numeric

      # Parse the value or return it as-is if it is invalid
      #
      # @param [#parse] parser
      #
      # @param [String] value
      #
      # @return [Time]
      #
      # @api private
      def self.parse_value(parser, value)
        parser.parse(value)
      rescue ArgumentError
        return value
      end

      private_class_method :parse_value

    end # class String
  end # module Typecast
end # module Virtus
