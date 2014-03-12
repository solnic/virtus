# v1.0.2 2014-12-03

* [improvement] Don’t override already-defined default values when freezing (amarshall)
* [improvement] Improved performance of `AttributeSet#each` (Antti)
* updated axiom-types dependency to ~> 0.1 (solnic)

[Compare v1.0.1..v1.0.2](https://github.com/solnic/virtus/compare/v1.0.1...v1.0.2)

# v1.0.1 2013-12-10

* [feature] re-introduce `ValueObject#with`, which was removed in the past (senny)
* [fixed] strict mode for Boolean type (solnic)

[Compare v1.0.0..v1.0.1](https://github.com/solnic/virtus/compare/v1.0.0...v1.0.1)

# v1.0.0 2013-10-16

This release no longer works with Ruby 1.8.7.

* [BREAKING CHANGE] Integrated with axiom-types, most of the attribute sub-classes are gone (solnic)
* [feature] Configurable coercion via coercible integration (solnic)
* [feature] Strict mode for coercions via `:strict` option (solnic)
* [feature] Lazy-loaded default values via `:lazy` option (solnic)
* [feature] Finalizing models solving circular-dependency issue (see #81) (solnic)
* [feature] Ability to cherry-pick which extension should be included (solnic)
* [feature] Ability to inject a custom coercer object via `:coercer` option (solnic)
* [feature] Extension module builder with pre-defined configuration for attributes (elskwid & solnic)
* [feature] `Virtus::Attribute` exposes a public API - you can easily build, rename and clone attribute instances and use their coercion power (solnic)
* [feature] Ability to reset attributes to their default values (pewniak747)
* [changed] A meaningful error will be raised if a reserved name is used as an attribute name (solnic)
* [changed] Default value can be set via private and protected methods now (solnic)
* [changed] New syntax for value objects (solnic)
* [changed] Default values are now set in the constructor for non-lazy attributes (solnic)
* [deprecated] `Virtus::Attribute.coerce` in favor of `Virtus.coerce` or a customized configured module (solnic)
* [deprecated] `include Virtus` in favor of `include Virtus.model` (for classes) or `Virtus.module` (for modules) (solnic)
* [deprecated] `include Virtus::ValueObject` in favor of `include Virtus.value_object` (solnic)
* [deprecated] `Virtus#attributes` in favor of `Virtus#attribute_set` (solnic)
* [fixed] const missing hook now works correctly in modules too (cored)
* [fixed] value object with Hash type works correctly (solnic)
* [fixed] issues with value-object subclasses and `#==` method (solnic)

[Compare v0.5.4..v1.0.0](https://github.com/solnic/virtus/compare/v0.5.4...v1.0.0)

# v0.5.4 2012-12-20

* [feature] Allow *any* enumerable to be a collection attribute (aptinio)
* [feature] Add Integer.to_datetime and Float.to_datetime coercion (brutuscat)
* [fixed] Fixed a regression with Hash attribute introduced by key/member coercion (shingara)
* [fixed] Change leading non-significant digit type coercion to be coerced (maskact)

[Compare v0.5.3..v0.5.4](https://github.com/solnic/virtus/compare/v0.5.3...v0.5.4)

# v0.5.3 2012-12-13

* [feature] Added Hash member type coercion [example](https://github.com/solnic/virtus#hash-attributes-coercion) (greyblake)
* [fixed] Fixed issues with String=>Integer coercion and e-notation (greyblake)
* [changed] Replaced internal DescendantsTracker with the extracted gem (solnic)
* [internal] Switched to rspec 2 and mutant for mutation testing (mbj)

[Compare v0.5.2..v0.5.3](https://github.com/solnic/virtus/compare/v0.5.2...v0.5.3)

# v0.5.2 2012-09-01

* [feature] Object is now the default attribute type (dkubb)
* [fixed] Fix module inclusion problems (dkubb)
* [fixed] Evaluate default values when freezing an object (mbj)
* [fixed] String representation of a big integer is now properly coerced to an integer (greyblake)
* [changed] AttributeSet is now a module responsible for defining attribute methods (emmanuel)

[Compare v0.5.1..v0.5.2](https://github.com/solnic/virtus/compare/v0.5.1...v0.5.2)

# v0.5.1 2012-06-11

* [fixed] EV properly handle nil as the value (solnic)

[Compare v0.5.0..v0.5.1](https://github.com/solnic/virtus/compare/v0.5.0...v0.5.1)

# v0.5.0 2012-06-08

* [feature] Support for extending objects (solnic)
* [feature] Support for defining attributes in modules (solnic)
* [feature] Support for Struct as an EmbeddedValue or ValueObject attribute (solnic)
* [changed] Allow any input for EmbeddedValue and ValueObject constructors (solnic)
* [changed] ValueObject instances cannot be duped or cloned (senny)

[Compare v0.4.2..v0.5.0](https://github.com/solnic/virtus/compare/v0.4.2...v0.5.0)

# v0.4.2 2012-05-08

* [updated] Bump backports dep to ~> 2.5.3 (solnic)

[Compare v0.4.1..v0.4.2](https://github.com/solnic/virtus/compare/v0.4.1...v0.4.2)

# v0.4.1 2012-05-06

* [changed] backports gem is now a runtime dependency (solnic)
* [BREAKING CHANGE] Renamed Virtus::DefaultValue#evaluate => Virtus::DefaultValue#call (solnic)
* [BREAKING CHANGE] Renamed Virtus::ValueObject::Equalizer to Virtus::Equalizer (dkubb)

[Compare v0.4.0..v0.4.1](https://github.com/solnic/virtus/compare/v0.4.0...v0.4.1)

# v0.4.0 2012-03-22

* [improvement] Add a caching mechanism for type lookups (solnic)
* [fixed] Fix attributes mass-assignment when nil is passed (fgrehm)
* [changed] Replace usage of #to_hash with Hash.try_convert (dkubb)

[Compare v0.3.0..v0.4.0](https://github.com/solnic/virtus/compare/v0.3.0...v0.4.0)

# v0.3.0 2012-02-25

* [feature] Support for default values from a symbol (which can be a method name) (solnic)
* [feature] Support for mass-assignment via custom setters not generated with attribute (fgrehm)
* [feature] Virtus::Coercion::String.to_constant handles namespaced names (dkubb)
* [feature] New coercion: Virtus::Coercion::Object.to_array (dkubb)
* [feature] New coercion: Virtus::Coercion::Object.to_hash (dkubb)
* [feature] New coercion: Virtus::Coercion::Object.to_string (dkubb)
* [feature] New coercion: Virtus::Coercion::Object.to_integer (dkubb)
* [changed] EmbeddedValue relies on @primitive setting rather than @model (mbj)
* [BREAKING CHANGE] Removed Attribute#writer_visibility in favor of Attribute#public_writer? (solnic)
* [BREAKING CHANGE] Removed Attribute#reader_visibility in favor of Attribute#public_reader? (solnic)
* [BREAKING CHANGE] Removed Attribute#instance_variable_name - this is a private ivar (solnic)
* [BREAKING CHANGE] Removed Equalizer#host_name and Equalizer#keys (solnic)

[Compare v0.2.0..v0.3.0](https://github.com/solnic/virtus/compare/v0.2.0...v0.3.0)

# v0.2.0 2012-02-08

* [feature] Support for Value Objects (emmanuel)
* [feature] New Symbol attribute (solnic)
* [feature] Time => Integer coercion (solnic)

[Compare v0.1.0..v0.2.0](https://github.com/solnic/virtus/compare/v0.1.0...v0.2.0)

# v0.1.0 2012-02-05

* [feature] New EmbeddedValue attribute (solnic)
* [feature] Array and Set attributes support member coercions (emmanuel)
* [feature] Support for scientific notation handling in string => integer coercion (dkubb)
* [feature] Handling of string => numeric coercion with a leading + sign (dkubb)
* [changed] Update Boolean coercion to handle "on", "off", "y", "n", "yes", "no" (dkubb)

[Compare v0.0.10..v0.1.0](https://github.com/solnic/virtus/compare/v0.0.10...v0.1.0)

# v0.0.10 2011-11-21

* [fixed] Default values are now duped on evaluate (rclosner)
* [fixed] Allow to override attribute mutator methods (senny)

[Compare v0.0.9..v0.0.10](https://github.com/solnic/virtus/compare/v0.0.9...v0.0.10)

# v0.0.9 2011-10-11

* [fixed] Fix in type lookup for anonymous classes (dkubb)

[Compare v0.0.8..v0.0.9](https://github.com/solnic/virtus/compare/v0.0.8...v0.0.9)

# v0.0.8 2011-08-25

* [fixed] Fixed conflict with ActiveModel (RichGuk)
* [changed] Renamed Coercion::String.to_class => Coercion::String.to_constant (emmanuel)

[Compare v0.0.7..v0.0.8](https://github.com/solnic/virtus/compare/v0.0.7...v0.0.8)

# v0.0.7 2011-07-31

* [BREAKING CHANGE] Attribute.primitive? has been removed (solnic)
* [fixed] Added missing coercion_method setting to Virtus::Attribute::Object (solnic)
* [general] Default value logic has been extracted into Attribute::DefaultValue class (solnic)
* [added] Virtus::Attribute::Class (solnic)

[Compare v0.0.6..v0.0.7](https://github.com/solnic/virtus/compare/v0.0.6...v0.0.7)

# v0.0.6 2011-07-30

* [BREAKING CHANGE] Moved Virtus.determine_type to a shared module Virtus::TypeLookup (dkubb)
* [BREAKING CHANGE] Attribute#typecast_to_primitive has been replaced by Attribute#coerce (solnic)
* [BREAKING CHANGE] Attribute#typecast logic was moved to Attribute#set which is now a public method (solnic)
* [feature] Added support for default values (solnic)
* [general] Added custom inspect for Attribute classes (solnic)
* [general] Added backports as a development dependency (dkubb)
* [changed] Options API has been extracted from Attribute to a support module Virtus::Options (solnic)
* [changed] Typecast classes have been replaced by a new hierarchy of Coercion classes like Coercion::String, Coercion::Integer etc. (solnic)
* [changed] Attribute#get, #get!, #set, #set! & #coerce are now part of the public API (solnic)

[Compare v0.0.5..v0.0.6](https://github.com/solnic/virtus/compare/v0.0.5...v0.0.6)

# v0.0.5 2011-07-10

* [bugfix] Fixed DescendantsTracker + ActiveSupport collision (dkubb)

[Compare v0.0.4..v0.0.5](https://github.com/solnic/virtus/compare/v0.0.4...v0.0.5)

# v0.0.4 2011-07-08

* [BREAKING CHANGE] attributes hash has been replaced by a specialized class AttributeSet (dkubb)
* [BREAKING CHANGE] Virtus::ClassMethods.attribute returns self instead of a created attribute (solnic)
* [changed] descendants tracking has been extracted into DescendantsTracker module (dkubb)
* [changed] Instance #primitive? method has been replaced by class utility method Virtus::Attribute.primitive? (solnic)
* [changed] Virtus::Attribute::String#typecast_to_primitive delegates to Virtus::Typecast::String.call (solnic)

[Compare v0.0.3..v0.0.4](https://github.com/solnic/virtus/compare/v0.0.3...v0.0.4)

# v0.0.3 2011-06-09

* [BREAKING CHANGE] Attribute classes were moved to Virtus::Attribute namespace (solnic)
* [BREAKING CHANGE] Attribute instance no longer holds the reference to a model (solnic)
* [BREAKING CHANGE] #typecast no longer receives an instance of a model (override #set which calls #typecast if you need that) (solnic)
* [changed] Adding reader/writer methods was moved from the attribute constructor to Virtus::ClassMethods.attribute (solnic)
* [changed] Typecast logic has been moved into separate classes (see Virtus::Typecast) (solnic)
* [added] Virtus::Attribute::DateTime#typecast supports objects which implement #to_datetime (solnic)
* [general] Internals have been cleaned up, simplified and properly documented (solnic)

[Compare v0.0.2..v0.0.3](https://github.com/solnic/virtus/compare/v0.0.2...v0.0.3)

# v0.0.2 2011-06-06

* [bugfix] Fixed #typecast in custom attribute classes (solnic)

[Compare v0.0.1..v0.0.2](https://github.com/solnic/virtus/compare/v0.0.1...v0.0.2)

# v0.0.1 2011-06-04

First public release :)
