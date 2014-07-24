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

  subject(:person) { Examples::Person.new(attributes) }

  let(:attributes) { {} }

  specify 'virtus creates accessor methods' do
    person.name = 'Peter'
    expect(person.name).to eq('Peter')
  end

  specify 'the constructor accepts a hash for mass-assignment' do
    john = Examples::Person.new(:name => 'John', :age => 13)
    expect(john.name).to eq('John')
    expect(john.age).to eq(13)
  end

  specify 'Boolean attributes have a predicate method' do
    expect(person).not_to be_doctor
    person.doctor = true
    expect(person).to be_doctor
  end

  context 'with attributes' do
    let(:attributes) { {:name => 'Jane', :age => 45, :doctor => true, :salary => 4500} }

    specify "#attributes returns the object's attributes as a hash" do
      expect(person.attributes).to eq(attributes)
    end

    specify "#to_hash returns the object's attributes as a hash" do
      expect(person.to_hash).to eq(attributes)
    end

    specify "#to_h returns the object's attributes as a hash" do
      expect(person.to_h).to eql(attributes)
    end
  end

  context 'inheritance' do
    specify 'inherits all the attributes from the base class' do
      fred = Examples::Manager.new(:name => 'Fred', :age => 29)
      expect(fred.name).to eq('Fred')
      expect(fred.age).to eq(29)
    end

    specify 'lets you add attributes to the base class at runtime' do
      frank = Examples::Manager.new(:name => 'Frank')
      Examples::Person.attribute :just_added, String
      frank.just_added = 'it works!'
      expect(frank.just_added).to eq('it works!')
    end

    specify 'lets you add attributes to the subclass at runtime' do
      person_jack = Examples::Person.new(:name => 'Jack')
      manager_frank = Examples::Manager.new(:name => 'Frank')

      Examples::Manager.attribute :just_added, String

      manager_frank.just_added = 'awesome!'

      expect(manager_frank.just_added).to eq('awesome!')
      expect(person_jack).not_to respond_to(:just_added)
      expect(person_jack).not_to respond_to(:just_added=)
    end
  end
end
