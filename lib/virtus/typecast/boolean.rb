module Virtus
  module Typecast
    class Boolean
      TRUE_VALUES  = [ 1, '1', 't', 'T', 'true',  'TRUE'  ].freeze
      FALSE_VALUES = [ 0, '0', 'f', 'F', 'false', 'FALSE' ].freeze

      BOOLEAN_MAP  = Hash[TRUE_VALUES.product([ true ]) + FALSE_VALUES.product([ false ]) ].freeze

      # Typecast value to TrueClass or FalseClass
      #
      # @param [Integer, String]
      #
      # @return [TrueClass, FalseClass]
      #
      # @api public
      def self.call(value)
        BOOLEAN_MAP.fetch(value, value)
      end
    end # Boolean
  end # Typecast
end # Virtus
