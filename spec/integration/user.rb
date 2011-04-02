require 'spec_helper'

class User
  include Character
end

describe User do
  it { described_class.should respond_to(:attribute)  }
  it { described_class.should respond_to(:attributes) }

  describe ".attribute" do
    before do
      described_class.attribute(:name,    String)
      described_class.attribute(:email,   String,  :accessor => :private)
      described_class.attribute(:address, String,  :accessor => :protected)
      described_class.attribute(:age,     Integer, :reader   => :private)
      described_class.attribute(:bday,    Date,    :writer   => :protected)
    end

    it "should create an attribute" do
      described_class.attributes.should have_key(:name)
    end

    it "should create an attribute of a correct type" do
      described_class.attributes[:name].should be_instance_of(Character::Attributes::String)
    end

    it "creates attribute writer" do
      described_class.public_instance_methods.should include(:"name=")
    end

    it "creates attribute reader" do
      described_class.public_instance_methods.should include(:name)
    end

    it "creates attribute private reader when :accessor => :private" do
      described_class.private_instance_methods.should include(:email)
    end

    it "creates attribute private writer when :accessor => :private" do
      described_class.private_instance_methods.should include(:"email=")
    end

    it "creates attribute protected reader when :accessor => :protected" do
      described_class.protected_instance_methods.should include(:address)
    end

    it "creates attribute protected writer when :accessor => :protected" do
      described_class.protected_instance_methods.should include(:"address=")
    end

    it "creates attribute private reader when :reader => :private" do
      described_class.private_instance_methods.should include(:age)
    end

    it "creates attribute protected writer when :writer => :protected" do
      described_class.protected_instance_methods.should include(:"bday=")
    end
  end
end
