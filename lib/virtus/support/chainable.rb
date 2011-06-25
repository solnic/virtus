module Virtus
  module Support
    module Chainable
      MODULES = {}

      def chainable(key)
        mod = MODULES[key] ||= Module.new
        include mod
        mod.module_eval { yield }
      end

    end # module Chainable
  end # module Support
end # module Virtus
