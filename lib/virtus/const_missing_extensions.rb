module Virtus
  module ConstMissingExtensions

    # Hooks into const missing process to determine types of attributes
    #
    # @param [String] name
    #
    # @return [Class]
    #
    # @api private
    def const_missing(name)
      Attribute::Builder.determine_type(name) or
        Axiom::Types.const_defined?(name) && Axiom::Types.const_get(name) or
        super
    end

  end
end
