require 'spec_helper'

describe Virtus::ValueObject::InstanceMethods, '#with' do
  subject { object.with(attributes) }

  let(:described_class) do
    Class.new do
      include Virtus::ValueObject

      attribute :first_name, String
      attribute :last_name,  String
    end
  end

  let(:object)     { described_class.new }
  let(:attributes) { Hash[:first_name => 'John', :last_name => 'Doe'] }

  let(:described_class) do
    Class.new do
      include Virtus::ValueObject

      attribute :first_name, String
      attribute :last_name,  String
    end
  end

  it { should be_instance_of(described_class) }

  its(:first_name) { should eql('John') }
  its(:last_name)  { should eql('Doe')  }
end
