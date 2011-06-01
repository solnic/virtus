module Virtus
  module DirtyTracking
    class Session
      attr_reader :subject

      # @api semipublic
      # TODO: document
      def initialize(subject)
        @subject = subject
      end

      # @api semipublic
      # TODO: document
      def original_attributes
        @_original_attributes ||= subject.attributes.dup
      end

      # @api semipublic
      # TODO: document
      def dirty_attributes
        (@_dirty_attributes ||= {}).update(complex_attributes)
      end

      # @api semipublic
      # TODO: document
      def dirty!(name, value)
        dirty_attributes[name] = value
      end

      # @api semipublic
      # TODO: document
      def dirty?(name = nil)
        name ? dirty_attributes.key?(name) : dirty_attributes.any?
      end

      private

      # @api private
      # TODO: document
      def complex_attributes
        values = {}

        complex_attributes_set.each do |name, attribute|
          value = subject.__send__(name)

          if original_attributes[name] != value
            values[name] = value
          end
        end

        values
      end

      # @api private
      def complex_attributes_set
        @_complex_attributes_set ||= subject.class.attributes.select do |name, attribute|
          attribute.complex?
        end
      end
    end # Session
  end # DirtyTracking
end # Virtus
