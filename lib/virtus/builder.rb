module Virtus

  # Class to build a Virtus module with it's own config
  #
  # This allows for individual Virtus modules to be included in
  # classes and not impacted by the global Virtus config,
  # which is implemented using Virtus::config.
  #
  # @private
  class Builder

    # Return module
    #
    # @return [Module]
    #
    # @api private
    attr_reader :mod

    # Return config
    #
    # @return [config]
    #
    # @api private
    attr_reader :config

    # @api private
    def self.call(options, &block)
      new(Configuration.build(options, &block)).mod
    end

    # @api private
    def self.pending
      @pending ||= []
    end

    # Initializes a new Builder
    #
    # @param [Configuration] config
    # @param [Module] mod
    #
    # @return [undefined]
    #
    # @api private
    def initialize(conf, mod = Module.new)
      @config, @mod = conf, mod
      add_included_hook
      add_extended_hook
    end

    # @api private
    def extensions
      [Model::Core]
    end

    # @api private
    def options
      config.to_h
    end

    private

    # Adds the .included hook to the anonymous module which then defines the
    # .attribute method to override the default.
    #
    # @return [Module]
    #
    # @api private
    def add_included_hook
      with_hook_context do |context|
        mod.define_singleton_method :included do |object|
          Builder.pending << object unless context.finalize?
          context.modules.each { |mod| object.send(:include, mod) }
          object.define_singleton_method(:attribute, context.attribute_method)
        end
      end
    end

    # @api private
    def add_extended_hook
      with_hook_context do |context|
        mod.define_singleton_method :extended do |object|
          context.modules.each { |mod| object.extend(mod) }
          object.define_singleton_method(:attribute, context.attribute_method)
        end
      end
    end

    # @api private
    def with_hook_context
      yield(HookContext.new(self, config))
    end

  end # class Builder

  # @private
  class ModelBuilder < Builder
  end # ModelBuilder

  # @private
  class ModuleBuilder < Builder

    private

    # @api private
    def add_included_hook
      with_hook_context do |context|
        mod.define_singleton_method :included do |object|
          super(object)
          object.extend(ModuleExtensions)
          ModuleExtensions.setup(object, context.modules)
          object.define_singleton_method(:attribute, context.attribute_method)
        end
      end
    end

  end # ModuleBuilder

  # @private
  class ValueObjectBuilder < Builder

    # @api private
    def extensions
      super + [
        Extensions::AllowedWriterMethods,
        ValueObject::AllowedWriterMethods,
        ValueObject::InstanceMethods
      ]
    end

    # @api private
    def options
      super.merge(:writer => :private)
    end

  end # ValueObjectBuilder

end # module Virtus
