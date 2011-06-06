module Virtus
  module Support
    module Chainable
      MODULES = {}

      def chainable(key, &block)
        mod = MODULES[key] ||= Module.new
        include mod
        mod.module_eval(&block)
      end
    end
  end
end
