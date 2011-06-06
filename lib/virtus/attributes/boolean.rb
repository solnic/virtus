module Virtus
  module Attributes
    class Boolean < Object
      primitive TrueClass

      TRUE_VALUES  = [ 1, '1', 't', 'T', 'true',  'TRUE'  ].freeze
      FALSE_VALUES = [ 0, '0', 'f', 'F', 'false', 'FALSE' ].freeze
      BOOLEAN_MAP  = Hash[
        TRUE_VALUES.product([ true ]) + FALSE_VALUES.product([ false ]) ].freeze

      def primitive?(value)
        value.equal?(true) || value.equal?(false)
      end

      def typecast_to_primitive(value)
        BOOLEAN_MAP.fetch(value, value)
      end

      private

      # Creates standard and boolean attribute reader methods.
      #
      # @api private
      def _create_reader
        super

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          chainable(:attribute) do
            #{reader_visibility}

            def #{name}?
              #{name}
            end
          end
        RUBY
      end
    end # Boolean
  end # Attributes
end # Virtus
