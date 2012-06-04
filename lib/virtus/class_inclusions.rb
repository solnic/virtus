module Virtus
  module ClassInclusions

    def self.included(descendant)
      super
      descendant.extend(ClassMethods)
      descendant.send(:include, InstanceMethods)
    end

  private

    def _attributes
      self.class.attributes
    end

    def allowed_writer_methods
      self.class.allowed_writer_methods
    end

  end # module ClassInclusions
end # module Virtus
