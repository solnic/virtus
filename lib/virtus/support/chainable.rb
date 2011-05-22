module Virtus
  module Support
    module Chainable
      MODULES = {}

      def chainable(key, &block)
        begin
          mod = (MODULES[key] ||= Module.new)
          include mod
          mod
        end.module_eval(&block)
      end
    end
  end
end
