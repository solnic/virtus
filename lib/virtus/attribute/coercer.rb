module Virtus
  class Attribute

    class Coercer
      def initialize(strategy, method)
        @strategy = strategy
        @method   = method
      end

      def call(value)
        @strategy[value.class].public_send(@method, value)
      end

    end # class Coercer

  end # class Attribute
end # module Virtus
