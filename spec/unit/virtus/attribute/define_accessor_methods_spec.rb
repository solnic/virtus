require 'spec_helper'

describe Virtus::Attribute, '#define_accessor_methods' do
  subject { object.define_accessor_methods(mod) }

  let(:object)   { described_class.new(:name, accessor) }
  let(:accessor) { double('accessor', :reader => reader, :writer => writer) }
  let(:reader)   { double('reader').as_null_object }
  let(:writer)   { double('writer').as_null_object }
  let(:mod)      { double('mod') }

  it 'delegates to reader#define_method' do
    reader.should_receive(:define_method).with(accessor, mod)
    subject
  end

  it 'delegates to writer#define_method' do
    writer.should_receive(:define_method).with(accessor, mod)
    subject
  end
end
