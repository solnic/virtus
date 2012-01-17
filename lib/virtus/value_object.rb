# -*- encoding: utf-8 -*-

require 'virtus'
require 'virtus/value_object/equalizer'

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
    def self.included(base)
      base.instance_eval do
        include ::Virtus
        include InstanceMethods
        extend ClassMethods
      end
    end

    module InstanceMethods
      def initialize(attributes = {})
        set_attributes(attributes)
      end

      def with(attribute_updates)
        self.class.new(get_attributes.merge(attribute_updates))
      end
    end

    module ClassMethods
      # Define an attribute on the receiver.
      # 
      # The Attribute will have private writer methods (eg., immutable instances)
      #   and be used in equality/equivalence comparisons
      def attribute(name, type, options = {})
        equalizer << name
        options[:writer] = :private

        super
      end

      # Define and include a module that provides Value Object semantics for
      #   this class. Included module will have #inspect, #eql?, #== and #hash
      #   methods whose definition is based on the _keys_ argument
      #
      # @return [Equalizer]
      #   An Equalizer module which defines #inspect, #eql?, #== and #hash
      #   for instances of this class
      #
      # @api public
      def equalizer
        @equalizer ||= begin
          equalizer = Equalizer.new(name || inspect)
          include equalizer
          equalizer
        end
      end
    end # module ClassMethods
  end # module ValueObject
end # module Virtus
