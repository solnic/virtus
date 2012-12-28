require 'spec_helper'

describe Virtus::Attribute::Boolean, '#define_reader_method' do
  subject { object.define_reader_method(mod) }

  let(:object)   { described_class.new(:active, accessor) }
  let(:accessor) { stub('accessor', :reader => reader) }
  let(:reader)   { stub('reader', :name => :active, :visibility => :public) }
  let(:mod)      { mock('mod', :define_reader_method => nil) }

  it { should equal(object) }

  it 'defines a reader method in the module' do
    mod.should_receive(:define_reader_method).with(reader, 'active?', :public)
    subject
  end
end
