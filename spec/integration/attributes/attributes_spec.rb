require 'spec_helper'


model = Class.new do
  include Virtus

  attribute :name, String
  attribute :age,  Integer
end

describe model do
  it { described_class.should respond_to(:attributes)  }

  describe ".attributes" do
    subject { model.attributes }

    it "returns an attributes hash" do
      subject.should == { :name => model.attributes[:name], :age => model.attributes[:age] }
    end
  end
end
