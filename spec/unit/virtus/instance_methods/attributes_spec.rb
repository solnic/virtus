require 'spec_helper'

describe Virtus::InstanceMethods do
  let(:model) do
    Class.new do
      include Virtus

      attribute :name,  String
      attribute :age,   Integer
      attribute :email, String, :accessor => :private
    end
  end

  let(:attributes) { { :name => 'john', :age => 28 } }

  describe '#attributes' do
    subject { object.attributes }

    let(:object) { model.new(attributes) }

    it { should be_instance_of(Hash) }

    it "returns a hash of attributes" do
      should eql(attributes)
    end
  end

  describe "#attributes=" do
    subject { object.attributes = attributes }

    let(:object) { model.new({}) }

    it "sets attribute values for publicly accessible attributes" do
      expect { subject }.to change { object.attributes.dup }.from({ :name => nil, :age => nil }).to(attributes)
    end
  end
end
