require 'spec_helper'

describe 'I can define attributes within a module' do
  before do
    module Examples
      module Common
        include Virtus
      end

      module Name
        include Common

        attribute :name, String
        attribute :gamer, Boolean
      end

      module Age
        include Common

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
    expect(Examples::User.attribute_set[:name]).to be_instance_of(Virtus::Attribute)
    expect(Examples::User.attribute_set[:gamer]).to be_instance_of(Virtus::Attribute::Boolean)

    expect(Examples::Admin.attribute_set[:name]).to be_instance_of(Virtus::Attribute)
    expect(Examples::Admin.attribute_set[:age]).to be_instance_of(Virtus::Attribute)

    user = Examples::Admin.new(:name => 'Piotr', :age => 29)
    expect(user.name).to eql('Piotr')
    expect(user.age).to eql(29)
  end

  specify 'including a module with attributes into an instance' do
    moderator = Examples::Moderator.new
    moderator.extend(Examples::Name, Examples::Age)

    moderator.attributes = { :name => 'John', :age => 21 }
    expect(moderator.name).to eql('John')
    expect(moderator.age).to eql(21)
  end
end
