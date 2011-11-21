# v0.0.10 to-be-released

* [fixed] Default values are now duped on evaluate (rclosner)
* [fixed] Allow to override attribute mutator methods (senny)

[Compare v0.0.9..master](https://github.com/solnic/virtus/compare/v0.0.9...master)

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
