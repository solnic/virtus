require 'spec_helper'

describe "virtus attribute definitions" do

  before do
    module Examples
      class Person
        include Virtus

        attribute :name, String
        attribute :age, Integer
        attribute :doctor, Boolean
      end
    end
  end
  after { Examples.send(:remove_const, 'Person') }


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
    subject { Examples::Person.new(:name => 'Jane', :age => 45, :doctor => true) }

    specify "#attributes returns the object's attributes as a hash" do
      subject.attributes.should == {:name => 'Jane', :age => 45, :doctor => true}
    end

    specify "#to_hash returns the object's attributes as a hash" do
      subject.to_hash.should == {:name => 'Jane', :age => 45, :doctor => true}
    end
  end
end
