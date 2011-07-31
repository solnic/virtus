module Virtus
  class Coercion

    # Coerce String values
    class String < Object
      primitive ::String

      TRUE_VALUES  = %w[ 1 t true  ].freeze
      FALSE_VALUES = %w[ 0 f false ].freeze
      BOOLEAN_MAP  = ::Hash[ TRUE_VALUES.product([ true ]) + FALSE_VALUES.product([ false ]) ].freeze

      NUMERIC_REGEXP = /\A(-?(?:0|[1-9]\d*)(?:\.\d+)?|(?:\.\d+))\z/.freeze

      # Coerce give value to a constant
      #
      # @example
      #   Virtus::Coercion::String.to_class('String') # => String
      #
      # @param [String] value
      #
      # @return [Object]
      #
      # @api public
      def self.to_class(value)
        # TODO: add support for namespaced classes like 'Virtus::Attribute::String'
        ::Object.const_get(value)
      end

      # Coerce given value to Time
      #
      # @example
      #   Virtus::Coercion::String.to_time(string)  # => Time object
      #
      # @param [String] value
      #
      # @return [Time]
      #
      # @api public
      def self.to_time(value)
        parse_value(::Time, value)
      end

      # Coerce given value to Date
      #
      # @example
      #   Virtus::Coercion::String.to_date(string)  # => Date object
      #
      # @param [String] value
      #
      # @return [Date]
      #
      # @api public
      def self.to_date(value)
        parse_value(::Date, value)
      end

      # Coerce given value to DateTime
      #
      # @example
      #   Virtus::Coercion::String.to_datetime(string)  # => DateTime object
      #
      # @param [String] value
      #
      # @return [DateTime]
      #
      # @api public
      def self.to_datetime(value)
        parse_value(::DateTime, value)
      end

      # Coerce value to TrueClass or FalseClass
      #
      # @example with "T"
      #   Virtus::Coercion::String.to_boolean('T')  # => true
      #
      # @example with "F"
      #   Virtus::Coercion::String.to_boolean('F')  # => false
      #
      # @param [#to_s]
      #
      # @return [Boolean]
      #
      # @api public
      def self.to_boolean(value)
        BOOLEAN_MAP.fetch(value.downcase, value)
      end

      # Coerce value to integer
      #
      # @example
      #   Virtus::Coercion::String.to_integer('1')  # => 1
      #
      # @param [Object] value
      #
      # @return [Integer]
      #
      # @api public
      def self.to_integer(value)
        to_numeric(value, :to_i)
      end

      # Coerce value to float
      #
      # @example
      #   Virtus::Coercion::String.to_float('1.2')  # => 1.2
      #
      # @param [Object] value
      #
      # @return [Float]
      #
      # @api public
      def self.to_float(value)
        to_numeric(value, :to_f)
      end

      # Coerce value to decimal
      #
      # @example
      #   Virtus::Coercion::String.to_decimal('1.2')  # => #<BigDecimal:b72157d4,'0.12E1',8(8)>
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
  end # class Coercion
end # module Virtus
