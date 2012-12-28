require 'spec_helper'

describe Virtus::Attribute, '#define_writer_method' do
  subject { object.define_writer_method(mod) }

  let(:object)      { described_class.new(name, accessor) }
  let(:name)        { :test }
  let(:writer_name) { :"#{name}=" }
  let(:writer)      { mock('writer', :name => writer_name, :visibility => :public) }
  let(:accessor)    { mock('accessor', :writer => writer) }
  let(:mod)         { mock('mod') }

  before do
    mod.stub(:define_writer_method).with(accessor, writer_name, :public)
  end

  it { should be(object) }

  it 'calls #define_writer_method on the module' do
    mod.should_receive(:define_writer_method).with(accessor, writer_name, :public)
    subject
  end
end
