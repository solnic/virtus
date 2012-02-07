module Virtus
  class Attribute

    # Symbol
    #
    # @example
    #   class Product
    #     include Virtus
    #
    #     attribute :code, Symbol
    #   end
    #
    #   product = Product.new(:code => :red)
    #
    class Symbol < Object
      primitive       ::Symbol
      coercion_method :to_symbol

    end # class Symbol
  end # class Attribute
end # module Virtus
