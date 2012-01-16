require 'spec_helper'

describe Virtus::Attribute::Boolean, '#define_reader_method' do
  subject { object.define_reader_method(mod) }

  let(:object) { described_class.new(:active)              }
  let(:mod)    { mock('mod', :define_reader_method => nil) }

  it { should equal(object) }

  it 'defines a reader method in the module' do
    mod.should_receive(:define_reader_method).with(object, 'active?', :public)
    subject
  end
end
