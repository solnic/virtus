require 'spec_helper'

describe Virtus::InstanceMethods, '#to_hash' do
  subject { object.to_hash }

  class Person
    include Virtus

    attribute :name,    String
    attribute :age,     Integer
    attribute :email,   String, :accessor => :private

    attribute :friend,  Person
  end

  context "when object has no recursive relation" do
    let(:model)      { Person                          }
    let(:attributes) { { :name => 'john', :age => 28 } }
    let(:object)     { model.new(attributes)           }

    it { should be_instance_of(Hash) }

    it "returns object hash" do
      should eql({ :name => 'john', :age => 28, :friend => nil})
    end
  end

  context "when object has a recursive relation" do
    let(:model)            { Person                          }
    let(:attributes)       { { :name => 'john', :age => 28 } }
    let(:attributes_child) { { :name => 'jack', :age => 31 } }
    let(:object)           { model.new(attributes)           }
    let(:object_child)     { model.new(attributes_child)     }

    before do
      object.friend = object_child
      object_child.friend = object
    end

    it { should be_instance_of(Hash) }

    it "returns object hash, excluding first level caller from the underlying hash" do
      should eql({ :name => 'john', :age => 28, :friend => { :name => 'jack', :age => 31 } })
    end
  end

end
