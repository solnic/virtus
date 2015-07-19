require 'spec_helper'

describe Virtus::Attribute, '#== (defined by including Virtus::Equalizer)' do
  let(:attribute) { described_class.build(String, :name => :name) }

  # Currently that's the way it works and it happens because default_value objects
  # don't have equalizer, resulting in  attributes object mismatch.
  # This behavior (and a spec) will need a change in future.
  it 'returns false when attributes have same type and options' do
    equal_attribute = described_class.build(String, :name => :name)
    expect(attribute == equal_attribute).to be_falsey
  end

  it 'returns false when attributes have different type' do
    different_attribute = described_class.build(Integer, :name => :name)
    expect(attribute == different_attribute).to be_falsey
  end

  it 'returns false when attributes have different options' do
    different_attribute = described_class.build(Integer, :name => :name_two)
    expect(attribute == different_attribute).to be_falsey
  end
end
