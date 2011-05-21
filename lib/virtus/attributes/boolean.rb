module Virtus
  module Attributes
    class Boolean < Object
      primitive TrueClass

      TRUE_VALUES  = [ 1, '1', 't', 'T', 'true',  'TRUE'  ].to_set.freeze
      FALSE_VALUES = [ 0, '0', 'f', 'F', 'false', 'FALSE' ].to_set.freeze

      def primitive?(value)
        value == true || value == false
      end

      def typecast(value, model = nil)
        if TRUE_VALUES.include?(value)
          true
        elsif FALSE_VALUES.include?(value)
          false
        else
          value
        end
      end
    end # Boolean
  end # Attributes
end # Virtus
