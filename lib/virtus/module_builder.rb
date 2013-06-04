module Virtus

  # Class to build a Virtus module with it's own configuration
  #
  # This allows for individual Virtus modules to be included in
  # classes and not impacted by the global Virtus configuration,
  # which is implemented using Virtus::Configuration.
  class ModuleBuilder

    # Builds a new Virtus module
    #
    # The block is passed to Virtus::Configuration
    #
    # @example
    #   ModuleBuilder.call do |config|
    #     # config settings
    #   end
    #
    # @return [Module]
    #
    # @api public
    def self.call(&block)
      config  = Configuration.new.call(&block)
      builder = self.new(config)
      builder.add_included_hook
      builder.mod
    end

    # Initializes a new ModuleBuilder
    #
    # @return [undefined]
    #
    # @api private
    def initialize(configuration)
      @configuration = configuration

      @mod = Module.new do
        include Virtus
      end
    end

    # Accessor for the anonymous module
    #
    # @return [Module]
    #
    # @api private
    def mod
      @mod
    end

    # Adds the .included hook to the anonymous module which then defines the
    # .attribute method to override the default.
    #
    # @return [Module]
    #
    # @api private
    def add_included_hook
      configuration    = @configuration
      attribute_method = self.attribute_method(configuration)

      mod.module_eval do
        define_singleton_method :included do |object|
          super(object)
          object.send :define_singleton_method, :attribute, attribute_method
        end
      end
    end

    # Wrapper for the attribute method (proc) that is used in .add_included_hook
    # The coercer is passed in the unused key :configured_coercer to allow the
    # property encapsulation by Virtus::Attribute::Coercer, where the
    # coercion method is known.
    #
    # @return [Proc]
    #
    # @api private
    def attribute_method(configuration)
      Proc.new do |name, type, options = {}|
        module_options = {
          :coerce => configuration.coerce,
          :configured_coercer => configuration.coercer
        }

        super(name, type, module_options.merge(options))
      end
    end

  end # class ModuleBuilder
end # module Virtus
