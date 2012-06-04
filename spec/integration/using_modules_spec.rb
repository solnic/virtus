require 'spec_helper'

describe 'I can define attributes within a module' do
  before do
    module Examples
      module Base
        include Virtus

        attribute :name, String
        attribute :age,  Integer
      end

      class User
        include Base
      end

      class Admin < User; end

      class Moderator; end
    end
  end

  specify 'including a module with attributes into a class' do
    Examples::User.attributes[:name].should be_instance_of(Virtus::Attribute::String)
    Examples::User.attributes[:age].should be_instance_of(Virtus::Attribute::Integer)

    Examples::Admin.attributes[:name].should be_instance_of(Virtus::Attribute::String)
    Examples::Admin.attributes[:age].should be_instance_of(Virtus::Attribute::Integer)

    user = Examples::User.new(:name => 'Piotr', :age => 29)
    user.name.should eql('Piotr')
    user.age.should eql(29)
  end

  specify 'including a module with attributes into an instance' do
    moderator = Examples::Moderator.new
    moderator.extend(Examples::Base)

    moderator.attributes = { :name => 'John', :age => 21 }
    moderator.name.should eql('John')
    moderator.age.should eql(21)
  end
end
