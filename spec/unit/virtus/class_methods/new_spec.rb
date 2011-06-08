require 'spec_helper'

describe Virtus::Attribute, '.new' do
  let(:model) do
    Class.new do
      include Virtus

      attribute :name, String

      attr_reader   :email
      attr_accessor :age

      def self.new(attributes)
        instance = super
        instance.age = 28
        instance
      end

      def initialize(attributes = {})
        super
        @email = "john@domain.com"
      end
    end
  end

  let(:object) do
    model.new(:name => "john")
  end

  it "sets the attributes" do
    object.name.should eql("john")
  end

  it "calls custom #initialize" do
    object.email.should eql("john@domain.com")
  end

  it "calls custom .new" do
    object.age.should eql(28)
  end
end
