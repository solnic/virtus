require 'spec_helper'

describe Virtus::Attribute, '#define_accessor_methods' do
  subject { object.define_accessor_methods(mod) }

  let(:object)   { described_class.new(:name, accessor) }
  let(:accessor) { mock('accessor', :reader => reader, :writer => writer) }
  let(:reader)   { mock('reader').as_null_object }
  let(:writer)   { mock('writer').as_null_object }
  let(:mod)      { stub('mod') }

  it 'delegates to reader#define_method' do
    reader.should_receive(:define_method).with(accessor, mod)
    subject
  end

  it 'delegates to writer#define_method' do
    writer.should_receive(:define_method).with(accessor, mod)
    subject
  end
end
