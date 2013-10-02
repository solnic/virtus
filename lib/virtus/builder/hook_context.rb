module Virtus
  class Builder

    # Context used for building "included" and "extended" hooks
    #
    # @private
    class HookContext
      attr_reader :builder, :config, :attribute_method

      # @api private
      def initialize(builder, config)
        @builder, @config = builder, config
        initialize_attribute_method
      end

      # @api private
      def modules
        modules = builder.extensions
        modules << Model::Constructor    if constructor?
        modules << Model::MassAssignment if mass_assignment?
        modules
      end

      # @api private
      def constructor?
        config.constructor
      end

      # @api private
      def mass_assignment?
        config.mass_assignment
      end

      # @api private
      def finalize?
        config.finalize
      end

      # @api private
      def initialize_attribute_method
        method_options = builder.options

        @attribute_method = lambda do |name, type = nil, options = {}|
          super(name, type, method_options.merge(options))
        end
      end

    end # HookContext

  end # Builder
end # Virtus
