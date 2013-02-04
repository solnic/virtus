require 'spec_helper'

describe "virtus attribute definitions" do

  before do
    module Examples
      class Person
        include Virtus

        attribute :name, String
        attribute :age, Integer
        attribute :doctor, Boolean
        attribute :salary, Decimal
      end

      class Manager < Person

      end
    end
  end

  subject { Examples::Person.new }

  specify 'virtus creates accessor methods' do
    subject.name = 'Peter'
    subject.name.should == 'Peter'
  end

  specify 'the constructor accepts a hash for mass-assignment' do
    john = Examples::Person.new(:name => 'John', :age => 13)
    john.name.should == 'John'
    john.age.should == 13
  end

  specify 'Boolean attributes have a getter with questionmark' do
    subject.doctor?.should be_false
    subject.doctor = true
    subject.doctor?.should be_true
  end

  context 'with attributes' do
    let(:attributes) { {:name => 'Jane', :age => 45, :doctor => true, :salary => 4500} }
    subject { Examples::Person.new(attributes) }

    specify "#attributes returns the object's attributes as a hash" do
      subject.attributes.should == attributes
    end

    specify "#to_hash returns the object's attributes as a hash" do
      subject.to_hash.should == attributes
    end
  end

  context 'inheritance' do
    specify 'inherits all the attributes from the base class' do
      fred = Examples::Manager.new(:name => 'Fred', :age => 29)
      fred.name.should == 'Fred'
      fred.age.should == 29
    end

    specify 'lets you add attributes to the base class at runtime' do
      frank = Examples::Manager.new(:name => 'Frank')
      Examples::Person.attribute :just_added, String
      frank.just_added = 'it works!'
      frank.just_added.should == 'it works!'
    end

    specify 'lets you add attributes to the subclass at runtime' do
      person_jack = Examples::Person.new(:name => 'Jack')
      manager_frank = Examples::Manager.new(:name => 'Frank')
      Examples::Manager.attribute :just_added, String

      manager_frank.just_added = 'awesome!'
      manager_frank.just_added.should == 'awesome!'
      person_jack.should_not respond_to(:just_added)
      person_jack.should_not respond_to(:just_added=)
    end
  end
end
