require 'spec_helper'

# TODO: split this into separate files - solnic
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
      object.attributes.should eql(attributes)
    end
  end

  describe '#to_hash' do
    it 'returns attributes' do
      object.to_hash.should == object.attributes
    end
  end

  describe "#attributes=" do
    before do
      object.attributes = attributes
    end

    it "sets attribute values for publicly accessible attributes" do
      object.attributes.should eql(attributes)
    end
  end
end
