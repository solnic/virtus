require 'spec_helper'

describe 'I can define attributes within a module' do
  before do
    module Examples
      module Name
        include Virtus

        attribute :name, String
      end

      module Age
        include Virtus

        attribute :age,  Integer
      end

      class User
        include Name
      end

      class Admin < User
        include Age
      end

      class Moderator; end
    end
  end

  specify 'including a module with attributes into a class' do
    Examples::User.attribute_set[:name].should be_instance_of(Virtus::Attribute::String)

    Examples::Admin.attribute_set[:name].should be_instance_of(Virtus::Attribute::String)
    Examples::Admin.attribute_set[:age].should be_instance_of(Virtus::Attribute::Integer)

    user = Examples::Admin.new(:name => 'Piotr', :age => 29)
    user.name.should eql('Piotr')
    user.age.should eql(29)
  end

  specify 'including a module with attributes into an instance' do
    moderator = Examples::Moderator.new
    moderator.extend(Examples::Name, Examples::Age)

    moderator.attributes = { :name => 'John', :age => 21 }
    moderator.name.should eql('John')
    moderator.age.should eql(21)
  end
end
