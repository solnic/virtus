require 'spec_helper'

describe Virtus::Attribute::Accessor, '#set' do
  subject { object.set(instance, value) }

  let(:object) { described_class.new(reader, writer) }

  let(:reader)   { mock('reader') }
  let(:writer)   { mock('writer') }
  let(:instance) { Class.new { attr_accessor :test }.new }
  let(:value)    { 'test' }

  it "delegates to writer" do
    writer.should_receive(:call).with(instance, value).and_return(value)
    expect(subject).to be(value)
  end
end
