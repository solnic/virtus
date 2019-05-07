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
      Attribute::Builder.determine_type(name) ||
        Axiom::Types.const_defined?(name) && Axiom::Types.const_get(name) ||
        super
    end
  end
end
