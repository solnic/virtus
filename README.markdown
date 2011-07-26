# Virtus [![Build Status](http://travis-ci.org/solnic/virtus.png)](http://travis-ci.org/solnic/virtus)

This is a partial extraction of the DataMapper [Property
API](http://rubydoc.info/github/datamapper/dm-core/master/DataMapper/Property)
with various modifications and improvements. The goal is to provide a common API
for defining attributes on a model so all ORMs/ODMs could use it instead of
reinventing the wheel all over again. It is also suitable for any other
usecase where you need to extend your ruby objects with attributes that require
data type coercions.

## Installation

    gem i virtus

## Basic Usage

    require 'virtus'

    class User
      include Virtus

      attribute :name,     String
      attribute :age,      Integer
      attribute :birthday, DateTime
    end

    # setting attributes in the constructor
    user = User.new(:name => 'Piotr', :age => 28)

    # attribute readers
    user.name  # => "Piotr"

    # hash of attributes
    user.attributes  # => { :name => "Piotr" }

    # automatic coercion
    user.age = '28'
    user.age  # => 28

    user.birthday = 'November 18th, 1983'
    user.birthday  # => #<DateTime: 1983-11-18T00:00:00+00:00 (4891313/2,0/1,2299161)>

## Custom Attributes

    require 'virtus'
    require 'json'

    module MyApp
      module Attributes
        class JSON < Virtus::Attribute::Object
          primitive Hash

          def coerce(value)
            ::JSON.parse(value)
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
    user.info  # => {"email"=>"john@domain.com"}

## Coercions

Virtus comes with a builtin coercion library. It's super easy to add your own
coercion classes. Take a look:

   require 'virtus'
   require 'digest/md5'

   class MD5 < Virtus::Attribute::Object
     primitive       String
     coercion_method :to_md5
   end

   module Virtus
     class Coercion
       class String < Virtus::Coercion::Object
         def self.to_md5(value)
           Digest::MD5.hexdigest(value)
         end
       end
     end
   end

   user = User.new(:name => 'Piotr', :password => 'foobar')
   user.name     # => 'Piotr'
   user.password # => '3858f62230ac3c915f300c664312c63f'

## Contributors

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Chris Corbyn ([d11wtq](https://github.com/d11wtq))
* Emmanuel Gomez ([emmanuel](https://github.com/emmanuel))

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Piotr Solnica. See LICENSE for details.
