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
      builder.add_extended_hook
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
      @module        = mod
    end

    # Adds the .included hook to the anonymous module which then defines the
    # .attribute method to override the default.
    #
    # @return [Module]
    #
    # @api private
    def add_included_hook
      attribute_proc  = attribute_method(configuration)
      constructor     = configuration.constructor
      mass_assignment = configuration.mass_assignment

      self.module.define_singleton_method :included do |object|
        super(object)
        object.send :include, Virtus::Model::Core
        object.send :include, Virtus::Model::Constructor    if constructor
        object.send :include, Virtus::Model::MassAssignment if mass_assignment
        object.send :define_singleton_method, :attribute, attribute_proc
      end
    end

    # @api private
    def add_extended_hook
      attribute_proc  = attribute_method(configuration)
      mass_assignment = configuration.mass_assignment

      self.module.define_singleton_method :extended do |object|
        super(object)
        object.extend Virtus::Model::Core
        object.extend Virtus::Model::MassAssignment if mass_assignment
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
