require 'spec_helper'

describe Virtus::ClassMethods, '.attribute' do
  let(:described_class) do
    Class.new { include Virtus }
  end

  specify { described_class.should respond_to(:attribute)  }

  context "in the class" do
    before do
      described_class.attribute(:name,    String)
      described_class.attribute(:email,   String,  :accessor => :private)
      described_class.attribute(:address, String,  :accessor => :protected)
      described_class.attribute(:age,     Integer, :reader   => :private)
      described_class.attribute(:bday,    Date,    :writer   => :protected)
    end

    let(:public_instance_methods)    { described_class.public_instance_methods.map    { |method| method.to_s } }
    let(:protected_instance_methods) { described_class.protected_instance_methods.map { |method| method.to_s } }
    let(:private_instance_methods)   { described_class.private_instance_methods.map   { |method| method.to_s } }

    it "returns self" do
      described_class.attribute(:name, String).should be(described_class)
    end

    it "creates an attribute of a correct type" do
      described_class.attributes[:name].should be_instance_of(Virtus::Attribute::String)
    end

    it "creates attribute writer" do
      public_instance_methods.should include('name=')
    end

    it "creates attribute reader" do
      public_instance_methods.should include('name')
    end

    it "creates attribute private reader when :accessor => :private" do
      private_instance_methods.should include('email')
    end

    it "creates attribute private writer when :accessor => :private" do
      private_instance_methods.should include('email=')
    end

    it "creates attribute protected reader when :accessor => :protected" do
      protected_instance_methods.should include('address')
    end

    it "creates attribute protected writer when :accessor => :protected" do
      protected_instance_methods.should include('address=')
    end

    it "creates attribute private reader when :reader => :private" do
      private_instance_methods.should include('age')
    end

    it "creates attribute protected writer when :writer => :protected" do
      protected_instance_methods.should include('bday=')
    end
  end

  context "in the descendants" do
    subject { described_class.attribute(:name, String).attributes[:name] }

    let(:descendant) { Class.new(described_class) }

    it 'updates the descendant attributes' do
      descendant.attributes.to_a.should be_empty
      @attribute = subject
      descendant.attributes.to_a.should eql([ @attribute ])
    end
  end
end
