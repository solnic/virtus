module Virtus
  module Typecast

    # String
    #
    class String < Object
      TRUE_VALUES  = %w[ 1 t true  ].freeze
      FALSE_VALUES = %w[ 0 f false ].freeze
      BOOLEAN_MAP  = ::Hash[ TRUE_VALUES.product([ true ]) + FALSE_VALUES.product([ false ]) ].freeze

      NUMERIC_REGEXP = /\A(-?(?:0|[1-9]\d*)(?:\.\d+)?|(?:\.\d+))\z/.freeze

      # @api public
      def self.to_time(value)
        ::Time.parse(value)
      rescue ArgumentError
        value
      end

      # @api public
      def self.to_date(value)
        ::Date.parse(value)
      rescue ArgumentError
        value
      end

      # @api public
      def self.to_datetime(value)
        ::DateTime.parse(value)
      rescue ArgumentError
        value
      end

      # Typecast value to TrueClass or FalseClass
      #
      # @example
      #   Virtus::Typecast::Boolean.call('T')  # => true
      #   Virtus::Typecast::Boolean.call('F')  # => false
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
      #   Virtus::Typecast::Numeric.to_f('1.2')  # => 1.2
      #
      # @param [Object] value
      #
      # @return [Float]
      #
      # @api public
      def self.to_f(value)
        to_numeric(value, :to_f)
      end

      # Typecast value to decimal
      #
      # @example
      #   Virtus::Typecast::Numeric.to_d('1.2')  # => #<BigDecimal:b72157d4,'0.12E1',8(8)>
      #
      # @param [Object] value
      #
      # @return [BigDecimal]
      #
      # @api public
      def self.to_d(value)
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

    end # class String
  end # module Typecast
end # module Virtus
