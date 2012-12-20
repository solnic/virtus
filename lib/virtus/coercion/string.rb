module Virtus
  class Coercion

    # Coerce String values
    class String < Object
      primitive ::String

      TRUE_VALUES  = %w[ 1 on  t true  y yes ].freeze
      FALSE_VALUES = %w[ 0 off f false n no  ].freeze
      BOOLEAN_MAP  = ::Hash[ TRUE_VALUES.product([ true ]) + FALSE_VALUES.product([ false ]) ].freeze

      INTEGER_REGEXP    = /[-+]?(?:[0-9]\d*)/.freeze
      EXPONENT_REGEXP   = /(?:[eE][-+]?\d+)/.freeze
      FRACTIONAL_REGEXP = /(?:\.\d+)/.freeze

      NUMERIC_REGEXP    = /\A(
        #{INTEGER_REGEXP}#{FRACTIONAL_REGEXP}?#{EXPONENT_REGEXP}? |
        #{FRACTIONAL_REGEXP}#{EXPONENT_REGEXP}?
      )\z/x.freeze

      # Coerce give value to a constant
      #
      # @example
      #   Virtus::Coercion::String.to_constant('String') # => String
      #
      # @param [String] value
      #
      # @return [Object]
      #
      # @api public
      def self.to_constant(value)
        names = value.split('::')
        names.shift if names.first.empty?
        names.inject(::Object) { |*args| constant_lookup(*args) }
      end

      # Lookup a constant within a module
      #
      # @param [Module] mod
      #
      # @param [String] name
      #
      # @return [Object]
      #
      # @api private
      def self.constant_lookup(mod, name)
        if mod.const_defined?(name, *EXTRA_CONST_ARGS)
          mod.const_get(name, *EXTRA_CONST_ARGS)
        else
          mod.const_missing(name)
        end
      end

      private_class_method :constant_lookup

      # Coerce give value to a symbol
      #
      # @example
      #   Virtus::Coercion::String.to_symbol('string') # => :string
      #
      # @param [String] value
      #
      # @return [Symbol]
      #
      # @api public
      def self.to_symbol(value)
        value.to_sym
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
        if value =~ /\A#{INTEGER_REGEXP}\z/
          value.to_i
        else
          # coerce to a Float first to evaluate scientific notation (if any)
          # that may change the integer part, then convert to an integer
          coerced = to_float(value)
          ::Float === coerced ? coerced.to_i : coerced
        end
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
          $1.public_send(method)
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
