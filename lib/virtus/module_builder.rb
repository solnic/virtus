module Virtus

  # Class to build a Virtus module with it's own configuration
  #
  # This allows for individual Virtus modules to be included in
  # classes and not impacted by the global Virtus configuration,
  # which is implemented using Virtus::Configuration.
  class ModuleBuilder

    # Return module
    #
    # @return [Module]
    #
    # @api private
    attr_reader :module

    # Return configuration
    #
    # @return [Configuration]
    #
    # @api private
    attr_reader :configuration

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
      config  = Configuration.build(&block)
      builder = new(config)
      builder.add_included_hook
      builder.module
    end

    # Initializes a new ModuleBuilder
    #
    # @param [Configuration] configuration
    #
    # @param [Module] mod
    #
    # @return [undefined]
    #
    # @api private
    def initialize(configuration, mod = Module.new)
      @configuration = configuration
      @module        = mod.send(:include, Virtus)
    end

    # Adds the .included hook to the anonymous module which then defines the
    # .attribute method to override the default.
    #
    # @return [Module]
    #
    # @api private
    def add_included_hook
      attribute_proc = attribute_method(configuration)

      self.module.define_singleton_method :included do |object|
        super(object)
        object.send :define_singleton_method, :attribute, attribute_proc
      end
    end

    # Wrapper for the attribute method that is used in .add_included_hook
    # The coercer is passed in the unused key :configured_coercer to allow the
    # property encapsulation by Virtus::Attribute::Coercer, where the
    # coercion method is known.
    #
    # @return [Proc(lambda)]
    #
    # @api private
    def attribute_method(configuration)
      lambda do |name, type, options = {}|
        module_options = {
          :coerce => configuration.coerce,
          :configured_coercer => configuration.coercer
        }

        super(name, type, module_options.merge(options))
      end
    end

  end # class ModuleBuilder
end # module Virtus
