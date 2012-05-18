require 'spec_helper'

describe 'I can define attributes within a module' do
  specify 'including a module with attributes' do
    module Examples
      module Base
        extend Virtus::Module

        attribute :name, String
        attribute :age,  Integer
      end

      class User
        include Base
      end

      class Admin < User; end
    end

    Examples::User.attributes[:name].should be_instance_of(Virtus::Attribute::String)
    Examples::User.attributes[:age].should be_instance_of(Virtus::Attribute::Integer)

    Examples::Admin.attributes[:name].should be_instance_of(Virtus::Attribute::String)
    Examples::Admin.attributes[:age].should be_instance_of(Virtus::Attribute::Integer)

    user = Examples::User.new(:name => 'Piotr', :age => 29)
    user.name.should eql('Piotr')
    user.age.should eql(29)
  end
end
