require 'spec_helper'

describe Virtus::Attribute, '#define_reader_method' do
  subject { object.define_reader_method(mod) }

  let(:object)   { described_class.new(name, accessor) }
  let(:name)     { :test }
  let(:accessor) { mock('accessor', :reader => reader) }
  let(:reader)   { mock('reader', :name => name, :visibility => :public) }
  let(:mod)      { mock('mod') }

  before do
    mod.stub(:define_reader_method).with(accessor, name, :public)
  end

  it { should be(object) }

  it 'calls #define_reader_method on the module' do
    mod.should_receive(:define_reader_method).with(accessor, name, :public)
    subject
  end
end
