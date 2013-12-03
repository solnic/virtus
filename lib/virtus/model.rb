module Virtus

  module Model

    # @api private
    def self.included(descendant)
      super
      descendant.send(:include, ClassInclusions)
    end

    # @api private
    def self.extended(descendant)
      super
      descendant.extend(Extensions)
    end

    module Core

      # @api private
      def self.included(descendant)
        super
        descendant.extend(ClassMethods)
        descendant.send(:include, ClassInclusions::Methods)
        descendant.send(:include, InstanceMethods)
      end
      private_class_method :included

      # @api private
      def self.extended(descendant)
        super
        descendant.extend(Extensions::Methods)
        descendant.extend(InstanceMethods)
      end
      private_class_method :included

    end # Core

    module Constructor

      # @api private
      def self.included(descendant)
        super
        descendant.send(:include, InstanceMethods::Constructor)
      end
      private_class_method :included

    end # Constructor

    module MassAssignment

      # @api private
      def self.included(descendant)
        super
        descendant.extend(Extensions::AllowedWriterMethods)
        descendant.send(:include, InstanceMethods::MassAssignment)
      end
      private_class_method :included

      # @api private
      def self.extended(descendant)
        super
        descendant.extend(Extensions::AllowedWriterMethods)
        descendant.extend(InstanceMethods::MassAssignment)
      end
      private_class_method :extended

    end # MassAssignment

  end # Model
end # Virtus
