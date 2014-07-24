Virtus
======

[![Gem Version](https://badge.fury.io/rb/virtus.png)][gem]
[![Build Status](https://secure.travis-ci.org/solnic/virtus.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/solnic/virtus.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/solnic/virtus.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/solnic/virtus/badge.png?branch=master)][coveralls]
[![Inline docs](http://inch-ci.org/github/solnic/virtus.png)][inchpages]

[gem]: https://rubygems.org/gems/virtus
[travis]: https://travis-ci.org/solnic/virtus
[gemnasium]: https://gemnasium.com/solnic/virtus
[codeclimate]: https://codeclimate.com/github/solnic/virtus
[coveralls]: https://coveralls.io/r/solnic/virtus
[inchpages]: http://inch-ci.org/github/solnic/virtus

This is a partial extraction of the DataMapper [Property
API](http://rubydoc.info/github/datamapper/dm-core/master/DataMapper/Property)
with various modifications and improvements. The goal is to provide a common API
for defining attributes on a model so all ORMs/ODMs could use it instead of
reinventing the wheel all over again. It is also suitable for any other
use case where you need to extend your ruby objects with attributes that require
data-type coercions.

Installation
------------

``` terminal
$ gem install virtus
```

or in your **Gemfile**

``` ruby
gem 'virtus'
```

Examples
--------

### Using Virtus with Classes

You can create classes extended with Virtus and define attributes:

``` ruby
class User
  include Virtus.model

  attribute :name, String
  attribute :age, Integer
  attribute :birthday, DateTime
end

user = User.new(:name => 'Piotr', :age => 29)
user.attributes # => { :name => "Piotr", :age => 29 }

user.name # => "Piotr"

user.age = '29' # => 29
user.age.class # => Fixnum

user.birthday = 'November 18th, 1983' # => #<DateTime: 1983-11-18T00:00:00+00:00 (4891313/2,0/1,2299161)>

# mass-assignment
user.attributes = { :name => 'Jane', :age => 21 }
user.name # => "Jane"
user.age  # => 21
```

### Cherry-picking extensions

``` ruby
# include attribute DSL + constructor + mass-assignment
class User
  include Virtus.model

  attribute :name, String
end

user = User.new(:name => 'Piotr')
user.attributes = { :name => 'John' }
user.attributes
# => {:name => 'John'}

# include attribute DSL + constructor
class User
  include Virtus.model(:mass_assignment => false)

  attribute :name, String
end

User.new(:name => 'Piotr')

# include just the attribute DSL
class User
  include Virtus.model(:constructor => false, :mass_assignment => false)

  attribute :name, String
end

user = User.new
user.name = 'Piotr'
```

### Using Virtus with Modules

You can create modules extended with Virtus and define attributes for later
inclusion in your classes:

```ruby
module Name
  include Virtus.module

  attribute :name, String
end

module Age
  include Virtus.module(:coerce => false)

  attribute :age, Integer
end

class User
  include Name, Age
end

user = User.new(:name => 'John', :age => 30)
```

### Dynamically Extending Instances

It's also possible to dynamically extend an object with Virtus:

```ruby
class User
  # nothing here
end

user = User.new
user.extend(Virtus.model)
user.attribute :name, String
user.name = 'John'
user.name # => 'John'
```

### Default Values

``` ruby
class Page
  include Virtus.model

  attribute :title, String

  # default from a singleton value (integer in this case)
  attribute :views, Integer, :default => 0

  # default from a singleton value (boolean in this case)
  attribute :published, Boolean, :default => false

  # default from a callable object (proc in this case)
  attribute :slug, String, :default => lambda { |page, attribute| page.title.downcase.gsub(' ', '-') }

  # default from a method name as symbol
  attribute :editor_title, String,  :default => :default_editor_title

  def default_editor_title
    published? ? title : "UNPUBLISHED: #{title}"
  end
end

page = Page.new(:title => 'Virtus README')
page.slug         # => 'virtus-readme'
page.views        # => 0
page.published    # => false
page.editor_title # => "UNPUBLISHED: Virtus README"

page.views = 10
page.views                    # => 10
page.reset_attribute(:views)  # => 0
page.views                    # => 0
```

### Embedded Value

``` ruby
class City
  include Virtus.model

  attribute :name, String
end

class Address
  include Virtus.model

  attribute :street,  String
  attribute :zipcode, String
  attribute :city,    City
end

class User
  include Virtus.model

  attribute :name,    String
  attribute :address, Address
end

user = User.new(:address => {
  :street => 'Street 1/2', :zipcode => '12345', :city => { :name => 'NYC' } })

user.address.street # => "Street 1/2"
user.address.city.name # => "NYC"
```

### Collection Member Coercions

``` ruby
# Support "primitive" classes
class Book
  include Virtus.model

  attribute :page_numbers, Array[Integer]
end

book = Book.new(:page_numbers => %w[1 2 3])
book.page_numbers # => [1, 2, 3]

# Support EmbeddedValues, too!
class Address
  include Virtus.model

  attribute :address,     String
  attribute :locality,    String
  attribute :region,      String
  attribute :postal_code, String
end

class PhoneNumber
  include Virtus.model

  attribute :number, String
end

class User
  include Virtus.model

  attribute :phone_numbers, Array[PhoneNumber]
  attribute :addresses,     Set[Address]
end

user = User.new(
  :phone_numbers => [
    { :number => '212-555-1212' },
    { :number => '919-444-3265' } ],
  :addresses => [
    { :address => '1234 Any St.', :locality => 'Anytown', :region => "DC", :postal_code => "21234" } ])

user.phone_numbers # => [#<PhoneNumber:0x007fdb2d3bef88 @number="212-555-1212">, #<PhoneNumber:0x007fdb2d3beb00 @number="919-444-3265">]

user.addresses # => #<Set: {#<Address:0x007fdb2d3be448 @address="1234 Any St.", @locality="Anytown", @region="DC", @postal_code="21234">}>
```

### Hash attributes coercion

``` ruby
class Package
  include Virtus.model

  attribute :dimensions, Hash[Symbol => Float]
end

package = Package.new(:dimensions => { 'width' => "2.2", :height => 2, "length" => 4.5 })
package.dimensions # => { :width => 2.2, :height => 2.0, :length => 4.5 }
```

### IMPORTANT note about Boolean type

Be aware that some libraries may do a terrible thing and define a global Boolean
constant which breaks virtus' constant type lookup, if you see issues with the
boolean type you can workaround it like that:

``` ruby
class User
  include Virtus.model

  attribute :admin, Axiom::Types::Boolean
end
```

This will be improved in Virtus 2.0.

### IMPORTANT note about member coercions

Virtus performs coercions only when a value is being assigned. If you mutate the value later on using its own
interfaces then coercion won't be triggered.

Here's an example:

``` ruby
class Book
  include Virtus.model

  attribute :title, String
end

class Library
  include Virtus.model

  attribute :books, Array[Book]
end

library = Library.new

# This will coerce Hash to a Book instance
library.books = [ { :title => 'Introduction to Virtus' } ]

# This WILL NOT COERCE the value because you mutate the books array with Array#<<
library.books << { :title => 'Another Introduction to Virtus' }
```

A suggested solution to this problem would be to introduce your own class instead of using Array and implement
mutation methods that perform coercions. For example:

``` ruby
class Book
  include Virtus.model

  attribute :title, String
end

class BookCollection < Array
  def <<(book)
   if book.kind_of?(Hash)
    super(Book.new(book))
   else
     super
   end
  end
end

class Library
  include Virtus.model

  attribute :books, BookCollection[Book]
end

library = Library.new
library.books << { :title => 'Another Introduction to Virtus' }
```

### Value Objects

``` ruby
class GeoLocation
  include Virtus.value_object

  values do
    attribute :latitude,  Float
    attribute :longitude, Float
  end
end

class Venue
  include Virtus.value_object

  values do
    attribute :name,     String
    attribute :location, GeoLocation
  end
end

venue = Venue.new(
  :name     => 'Pub',
  :location => { :latitude => 37.160317, :longitude => -98.437500 })

venue.location.latitude # => 37.160317
venue.location.longitude # => -98.4375

# Supports object's equality

venue_other = Venue.new(
  :name     => 'Other Pub',
  :location => { :latitude => 37.160317, :longitude => -98.437500 })

venue.location === venue_other.location # => true
```

### Custom Coercions

``` ruby
require 'json'

class Json < Virtus::Attribute
  def coerce(value)
    value.is_a?(::Hash) ? value : JSON.parse(value)
  end
end

class User
  include Virtus.model

  attribute :info, Json, default: {}
end

user = User.new
user.info = '{"email":"john@domain.com"}' # => {"email"=>"john@domain.com"}
user.info.class # => Hash

# With a custom attribute encapsulating coercion-specific configuration
class NoisyString < Virtus::Attribute
  def coerce(value)
    coercer[value.class].to_string.upcase
  end
end

class User
  include Virtus.model

  attribute :scream, NoisyString
end

user = User.new(:scream => 'hello world!')
user.scream # => "HELLO WORLD!"
```

### Private Attributes

``` ruby
class User
  include Virtus.model

  attribute :unique_id, String, :writer => :private

  def set_unique_id(id)
    self.unique_id = id
  end
end

user = User.new(:unique_id => '1234-1234')
user.unique_id # => nil

user.unique_id = '1234-1234' # => NoMethodError: private method `unique_id='

user.set_unique_id('1234-1234')
user.unique_id # => '1234-1234'
```

### Overriding setters

``` ruby
class User
  include Virtus.model

  attribute :name, String

  def name=(new_name)
    custom_name = nil
    if new_name == "Godzilla"
      custom_name = "Can't tell"
    end
    super custom_name || new_name
  end
end

user = User.new(name: "Frank")
user.name # => 'Frank'

user = User.new(name: "Godzilla")
user.name # => 'Can't tell'

```

## Strict Coercion Mode

By default Virtus returns the input value even when it couldn't coerce it to the expected type.
If you want to catch such cases in a noisy way you can use the strict mode in which
Virtus raises an exception when it failed to coerce an input value.

``` ruby
class User
  include Virtus.model(:strict => true)

  attribute :admin, Boolean
end

# this will raise an error
User.new :admin => "can't really say if true or false"
```

## Building modules with custom configuration

You can also build Virtus modules that contain their own configuration.

```ruby
YupNopeBooleans = Virtus.model { |mod|
  mod.coerce = true
  mod.coercer.config.string.boolean_map = { 'nope' => false, 'yup' => true }
}

class User
  include YupNopeBooleans

  attribute :name, String
  attribute :admin, Boolean
end

# Or just include the module straight away ...
class User
  include Virtus.model(:coerce => false)

  attribute :name, String
  attribute :admin, Boolean
end
```

## Attribute Finalization and Circular Dependencies

If a type references another type which happens to not be available yet you need
to use lazy-finalization of attributes and finalize virtus manually after all
types have been already loaded:

``` ruby
# in blog.rb
class Blog
  include Virtus.model(:finalize => false)

  attribute :posts, Array['Post']
end

# in post.rb
class Post
  include Virtus.model(:finalize => false)

  attribute :blog, 'Blog'
end

# after loading both files just do:
Virtus.finalize

# constants will be resolved:
Blog.attribute_set[:posts].member_type.primitive # => Post
Post.attribute_set[:blog].type.primitive # => Blog
```

Ruby version support
--------------------

Virtus is known to work correctly with the following rubies:

* 1.9.3
* 2.0.0
* 2.1.2
* jruby
* (probably) rbx

Credits
-------

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Chris Corbyn ([d11wtq](https://github.com/d11wtq))
* Emmanuel Gomez ([emmanuel](https://github.com/emmanuel))
* Fabio Rehm ([fgrehm](https://github.com/fgrehm))
* Ryan Closner ([rclosner](https://github.com/rclosner))
* Markus Schirp ([mbj](https://github.com/mbj))
* Yves Senn ([senny](https://github.com/senny))

Contributing
-------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.
