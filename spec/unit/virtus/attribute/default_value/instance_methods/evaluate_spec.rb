require 'spec_helper'

describe Virtus::Attribute::DefaultValue, '#evaluate' do
  subject { object.evaluate(instance) }

  let(:object)    { described_class.new(attribute, value)     }
  let(:attribute) { Virtus::Attribute::String.new(:title) }
  let(:instance)  { Class.new }

  context 'with a non-callable value' do
    let(:value) { 'something' }
    it { should eql(value) }
  end

  context 'with a callable value' do
    let(:value) { lambda { |instance, attribute| attribute.name } }
    it { should be(:title) }
  end
end
