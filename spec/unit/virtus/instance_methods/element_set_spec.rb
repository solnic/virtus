require 'spec_helper'

describe Virtus::InstanceMethods, '#[]=' do
  subject { object[:name] = value }

  let(:described_class) do
    Class.new do
      include Virtus
      attribute :name, String
    end
  end

  let(:object) do
    described_class.new
  end

  let(:value) do
    'john'
  end

  it 'returns the value' do
    should eql(value)
  end

  it 'sets value of an attribute' do
    expect { subject }.to change { object.name }.from(nil).to(value)
  end
end
