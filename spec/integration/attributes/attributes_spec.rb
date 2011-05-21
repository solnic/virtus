require 'spec_helper'

class User
  include Virtus

  attribute :name, String
  attribute :age,  Integer
end

describe User do
  it { described_class.should respond_to(:attributes)  }

  describe ".attributes" do
    subject { User.attributes }

    it "returns an attributes hash" do
      subject.should == { :name => User.attributes[:name], :age => User.attributes[:age] }
    end
  end
end
