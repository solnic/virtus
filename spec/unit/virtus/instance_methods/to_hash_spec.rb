require 'spec_helper'

describe Virtus::InstanceMethods, '#to_hash' do
  subject { object.to_hash }

  let(:model) do
    Class.new do
      include Virtus

      attribute :name,  String
      attribute :age,   Integer
      attribute :email, String, :accessor => :private
    end
  end

  let(:object) { model.new(attributes) }
  let(:attributes) { { :name => 'john', :age => 28 } }

  it { should be_instance_of(Hash) }

  it 'returns attributes' do
    should eql(attributes)
  end
end
