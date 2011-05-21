require 'spec_helper'

describe Virtus::Attributes, '.new' do
  let(:model) do
    Class.new do
      include Virtus

      attribute :name, String

      attr_reader   :email
      attr_accessor :age

      def self.new(attributes)
        model = super
        model.age = 28
        model
      end

      def initialize(a=nil)
        @email = "john@domain.com"
      end
    end
  end

  let(:object) do
    model.new(:name => "john")
  end

  it "sets the attributes" do
    object.name.should == "john"
  end

  it "calls custom #initialize" do
    object.email.should == "john@domain.com"
  end

  it "calls custom .new" do
    object.age.should == 28
  end
end
