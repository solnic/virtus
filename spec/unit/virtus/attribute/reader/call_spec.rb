require 'spec_helper'

describe Virtus::Attribute::Reader, '#call' do
  subject { object.call(instance) }

  let(:object)   { described_class.new(:title) }
  let(:instance) { Object.new }
  let(:value)    { 'test' }

  before { instance.instance_variable_set("@title", value) }

  it { should == value }
end
