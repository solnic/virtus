module Virtus

  # Include this Module for Value Object semantics
  #
  # The idea is that instances should be immutable and compared based on state
  #   (rather than identity, as is typically the case)
  #
  # @example
  #   class GeoLocation
  #     include Virtus::ValueObject
  #     attribute :latitude,  Float
  #     attribute :longitude, Float
  #   end
  #
  #   location = GeoLocation.new(:latitude => 10, :longitude => 100)
  #   same_location = GeoLocation.new(:latitude => 10, :longitude => 100)
  #   location == same_location       #=> true
  #   hash = { location => :foo }
  #   hash[same_location]             #=> :foo
  module ValueObject

    # Callback to configure including Class as a Value Object
    #
    # Including Class will include Virtus and have additional
    #   value object semantics defined in this module
    #
    # @return [Undefined]
    #
    # TODO: stacking modules is getting painful
    #   time for Facets' module_inheritance, ActiveSupport::Concern or the like
    #
    # @api private
    def self.included(base)
      Virtus.warn "Virtus::ValueObject is deprecated and will be removed in 1.0.0 #{caller.first}"

      base.instance_eval do
        include Virtus
        include InstanceMethods
        extend ClassMethods
        extend AllowedWriterMethods
        private :attributes=
      end
    end

    private_class_method :included

    module InstanceMethods

      # ValueObjects are immutable and can't be cloned
      #
      # They always represent the same value
      #
      # @example
      #
      #   value_object.clone === value_object # => true
      #
      # @return [self]
      #
      # @api public
      def clone
        self
      end
      alias dup clone

      # Create a new ValueObject by combining the passed attribute hash with
      # the instances attributes.
      #
      # @example
      #
      #   number = PhoneNumber.new(kind: "mobile", number: "123-456-78-90")
      #   number.with(number: "987-654-32-10")
      #   # => #<PhoneNumber kind="mobile" number="987-654-32-10">
      #
      # @return [Object]
      #
      # @api public
      def with(attribute_updates)
        self.class.new(attribute_set.get(self).merge(attribute_updates))
      end

    end

    module AllowedWriterMethods
      # The list of writer methods that can be mass-assigned to in #attributes=
      #
      # @return [Set]
      #
      # @api private
      def allowed_writer_methods
        @allowed_writer_methods ||=
          begin
            allowed_writer_methods = super
            allowed_writer_methods += attribute_set.map{|attr| "#{attr.name}="}
            allowed_writer_methods.to_set.freeze
          end
      end
    end

    module ClassMethods

      # Define an attribute on the receiver
      #
      # The Attribute will have private writer methods (eg., immutable instances)
      #   and be used in equality/equivalence comparisons
      #
      # @example
      #   class GeoLocation
      #     include Virtus::ValueObject
      #
      #     attribute :latitude,  Float
      #     attribute :longitude, Float
      #   end
      #
      # @see Virtus::ClassMethods.attribute
      #
      # @return [self]
      #
      # @api public
      def attribute(name, type, options = {})
        equalizer << name
        super name, type, options.merge(:writer => :private)
      end

      # Define and include a module that provides Value Object semantics
      #
      # Included module will have #inspect, #eql?, #== and #hash
      # methods whose definition is based on the _keys_ argument
      #
      # @example
      #   virtus_class.equalizer
      #
      # @return [Equalizer]
      #   An Equalizer module which defines #inspect, #eql?, #== and #hash
      #   for instances of this class
      #
      # @api public
      def equalizer
        @equalizer ||=
          begin
            equalizer = Virtus::Equalizer.new(name || inspect)
            include equalizer
            equalizer
          end
      end

    end # module ClassMethods

  end # module ValueObject

end # module Virtus
