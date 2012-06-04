module Virtus
  module ClassExtensions

    def self.extended(descendant)
      super
      descendant.extend(ClassMethods)
      descendant.extend(InstanceExtensions::AllowedWriterMethods)
      descendant.send(:include, Virtus::InstanceMethods)
      descendant.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def _attributes
        self.class.attributes
      end

      def allowed_writer_methods
        self.class.allowed_writer_methods
      end
    end

  end # module Class
end # module Virtus
