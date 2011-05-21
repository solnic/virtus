require 'spec_helper'

describe Virtus do
  let(:model) do
    Class.new do
      include Virtus

      attribute :name,  String
      attribute :age,   Integer
      attribute :email, String, :accessor => :private
    end
  end

  let(:object) do
    model.new(attributes)
  end

  let(:attributes) do
    { :name => 'john', :age => 28 }
  end

  describe '#attributes' do
    it "returns a hash of attributes" do
      object.attributes.should == attributes
    end
  end

  describe "#attributes=" do
    before do
      object.attributes = attributes
    end

    it "sets attribute values for publicly accessible attributes" do
      object.attributes.should == attributes
    end
  end
end
