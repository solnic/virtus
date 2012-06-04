module Virtus
  module ClassInclusions

    def self.included(descendant)
      super
      descendant.extend(ClassMethods)
      descendant.send(:include, InstanceMethods)
    end

  private

    def attribute_set
      self.class.attribute_set
    end

    def allowed_writer_methods
      self.class.allowed_writer_methods
    end

  end # module ClassInclusions
end # module Virtus
