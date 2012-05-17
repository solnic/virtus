require 'spec_helper'

describe Virtus::InstanceMethods, '#to_hash' do
  subject { object.to_hash }

  context "when object has only singular associations" do
    class Person
      include Virtus

      attribute :name,    String
      attribute :age,     Integer

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
      let(:attributes_child) { { :name => 'jack', :age => 31   } }

      let(:attributes)       { { :name => 'john', :age => 28, :friend => attributes_child } }

      let(:object)           { model.new(attributes)           }

      it { should be_instance_of(Hash) }

      it "returns object hash, excluding first level caller from the underlying hash" do
        should eql({ :name => 'john', :age => 28,
                     :friend => { :name => 'jack', :age => 31, :friend => nil } })
      end
    end
  end

  context "when object has plural (array) recursive relation within" do
    class User
      include Virtus

      attribute :name,    String
      attribute :age,     Integer
      attribute :friends, Array[User]
    end

    let(:model)              { User                            }
    let(:attributes_child_1) { { :name => 'jack', :age => 31 } }
    let(:attributes_child_2) { { :name => 'jim',  :age => 25 } }
    let(:attributes)         { { :name => 'john', :age => 28, :friends => [attributes_child_1, attributes_child_2] } }
    let(:object)             { model.new(attributes)           }

    it { should be_instance_of(Hash) }

    it "returns object hash, excluding first level caller from the underlying hash" do
      should eql({ :name => 'john', :age => 28,
                   :friends => [
                                { :name => 'jack', :age => 31, :friends => nil },
                                { :name => 'jim', :age => 25, :friends => nil  } ] })
    end
  end
end
