require 'spec_helper'

describe Virtus::ClassMethods, '.attribute' do
  let(:described_class) do
    Class.new { include Virtus }
  end

  (Virtus::Attribute.descendants + [Virtus::Attribute::Object]).each do |attribute_class|
    context "with #{attribute_class.inspect}" do
      subject { described_class.attribute(:name, attribute_class) }
      specify { subject.attributes[:name].should be_instance_of(attribute_class) }
    end
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
    let(:descendant) { Class.new(described_class) }

    context 'adding an attribute to the superclass' do
      subject { described_class.attribute(:name, String).attributes[:name] }

      it 'updates the descendant attributes' do
        descendant.attributes.to_a.should be_empty
        @attribute = subject
        descendant.attributes.to_a.should eql([ @attribute ])
      end

      it "adds attribute accessor methods to the descendant" do
        subject
        descendant.instance_methods.map(&:to_s).should include('name', 'name=')
      end
    end

    context 'adding an attribute to a descendant' do
      before { descendant.attribute(:name, String) }
      subject { descendant.attributes[:name] }

      it "adds the attribute to the descendant's attributes" do
        subject.name.should eql(:name)
        descendant.attributes.to_a.should eql([ subject ])
      end

      it "does not add the attribute to the superclass's attributes" do
        descendant.attributes.to_a.should eql([ subject ])
        described_class.attributes.to_a.should eql([ ])
      end

      it "adds attribute accessor methods to the descendant" do
        descendant.instance_methods.map(&:to_s).should include('name', 'name=')
      end

      it "does not add attribute accessor methods to the superclass" do
        described_class.instance_methods.map(&:to_s).should_not include('name', 'name=')
      end
    end

    context 'an attribute on the superclass and on the descendant' do
      before do
        described_class.attribute(:name, String)
        descendant.attribute(:descendant_name, String)
      end

      it "adds accessor methods for both attributes to the descendant" do
        descendant.instance_methods.map(&:to_s).should include('name', 'name=')
        descendant.instance_methods.map(&:to_s).should include('descendant_name', 'descendant_name=')
      end

      it "adds accessor methods for the superclass attribute to the superclass" do
        described_class.instance_methods.map(&:to_s).should include('name', 'name=')
      end

      it "does not add accessor methods for the descendant attribute to the superclass" do
        described_class.instance_methods.map(&:to_s).should_not include('descendant_name', 'descendant_name=')
      end
    end
  end
end
