virtus
======

[![Build Status](http://travis-ci.org/solnic/virtus.png)](http://travis-ci.org/solnic/virtus)

This is a partial extraction of the DataMapper [Property
API](http://rubydoc.info/github/datamapper/dm-core/master/DataMapper/Property)
with various modifications and improvements. The goal is to provide a common API
for defining attributes on a model so all ORMs/ODMs could use it instead of
reinventing the wheel all over again. It is also suitable for any other
usecase where you need to extend your ruby objects with attributes that require
data type coercions.

Installation
------------

``` terminal
$ gem install virtus
```

or

``` ruby
# ./Gemfile

gem 'virtus'
```

*IMPORTANT*: If you are still using Ruby 1.8.7 then you also have to install backports gem!

Examples
--------


``` ruby
require 'virtus'

class User
  include Virtus

  attribute :name, String
  attribute :age, Integer
  attribute :birthday, DateTime
end

user = User.new :name => 'Piotr', :age => 28
user.attributes
  # => { :name => "Piotr", :age => 28 }

user.name
  # => "Piotr"

user.age = '28'
  # => 28
user.age.class
  # => Fixnum

user.birthday = 'November 18th, 1983'
  # => #<DateTime: 1983-11-18T00:00:00+00:00 (4891313/2,0/1,2299161)>
```


**Default values**

``` ruby
require 'virtus'

class Page
  include Virtus

  attribute :title, String
  attribute :views, Integer, :default => 0
  attribute :slug, String, :default => lambda { |page, attribute| page.title.downcase.gsub(' ', '-') }
end

page = Page.new :title => 'Virtus Is Awesome'
page.slug
  # => 'virtus-is-awesome'
page.views
  # => 0
```

**Embedded Value**

``` ruby
class City
  include Virtus

  attribute :name, String
end

class Address
  include Virtus

  attribute :street,  String
  attribute :zipcode, String
  attribute :city,    City
end

class User
  include Virtus

  attribute :name,    String
  attribute :address, Address
end

user = User.new(:address => {
  :street => 'Street 1/2', :zipcode => '12345', :city => { :name => 'NYC' } })

user.address.street # => "Street 1/2"
user.address.city.name # => "NYC"
```

**Adding Coercions**

Virtus comes with a builtin coercion library.
It's super easy to add your own coercion classes.
Take a look:

``` ruby
require 'virtus'
require 'digest/md5'

# Our new attribute type
class MD5 < Virtus::Attribute::Object
  primitive String
  coercion_method :to_md5
end

# Defining the Coercion method
module Virtus
  class Coercion
    class String < Virtus::Coercion::Object
      def self.to_md5(value)
        Digest::MD5.hexdigest value
      end
    end
  end
end

# And now the user!
class User
  include Virtus

  attribute :name, String
  attribute :password, MD5
end

user = User.new :name => 'Piotr', :password => 'foobar'
user.name
  # => 'Piotr'
user.password
  # => '3858f62230ac3c915f300c664312c63f'
```

**Custom Attributes**

``` ruby
require 'virtus'
require 'json'

module MyAppClass

  # Defining the custom attribute(s)
  module Attributes
    class JSON < Virtus::Attribute::Object
      primitive Hash

      def coerce(value)
        ::JSON.parse value
      end
    end
  end

  class User
    include Virtus

    attribute :info, Attributes::JSON
  end
end

user = MyApp::User.new
user.info = '{"email":"john@domain.com"}'
  # => {"email"=>"john@domain.com"}
user.info.class
  # => Hash
```


Credits
-------

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Chris Corbyn ([d11wtq](https://github.com/d11wtq))
* Emmanuel Gomez ([emmanuel](https://github.com/emmanuel))
* Ryan Closner ([rclosner](https://github.com/rclosner))
* Yves Senn ([senny](https://github.com/senny))


Contributing
-------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

License
-------

Copyright (c) 2011 Piotr Solnica

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
