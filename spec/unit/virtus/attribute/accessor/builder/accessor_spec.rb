require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '#accessor' do
  subject { object.accessor }

  let(:object)   { described_class.new('test', type) }
  let(:type)     { mock('attribute_type') }
  let(:reader)   { mock('reader') }
  let(:writer)   { mock('writer') }
  let(:accessor) { mock('accessor') }
  let(:klass)    { mock('accessor_class') }

  before do
    object.stub!(:reader => reader, :writer => writer, :accessor_class => klass)
    klass.should_receive(:new).with(reader, writer).and_return(accessor)
  end

  it { should be(accessor) }
end
