module Virtus
  module Attributes
    class Boolean < Object
      primitive TrueClass

      TRUE_VALUES  = [ 1, '1', 't', 'T', 'true',  'TRUE'  ].freeze
      FALSE_VALUES = [ 0, '0', 'f', 'F', 'false', 'FALSE' ].freeze
      BOOLEAN_MAP  = Hash[
        TRUE_VALUES.product([ true ]) + FALSE_VALUES.product([ false ]) ].freeze

      def primitive?(value)
        value == true || value == false
      end

      def typecast_to_primitive(value, model = nil)
        BOOLEAN_MAP.fetch(value, value)
      end
    end # Boolean
  end # Attributes
end # Virtus
