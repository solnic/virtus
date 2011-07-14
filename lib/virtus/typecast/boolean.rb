module Virtus
  module Typecast

    # Typecast defined values into true or false.
    # See TRUE_VALUES and FALSE_VALUES constants for a reference.
    class Boolean

      TRUE_VALUES  = %w[ 1 t true  ].freeze
      FALSE_VALUES = %w[ 0 f false ].freeze
      BOOLEAN_MAP  = Hash[ TRUE_VALUES.product([ true ]) + FALSE_VALUES.product([ false ]) ].freeze

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
        BOOLEAN_MAP.fetch(value.to_s.downcase, value)
      end

    end # class Boolean
  end # module Typecast
end # module Virtus
