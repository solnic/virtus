require 'spec_helper'

describe Virtus::ModuleBuilder, '.add_included_hook' do
  subject { object.add_included_hook }

  let(:object)          { described_class.new(Virtus::Configuration.new) }
  let(:including_class) { Class.new }

  before do
    including_class.should_receive(:define_singleton_method).with(:attribute, kind_of(Proc))
  end

  it 'adds the attribute method on the including class' do
    subject
    including_class.send :include, object.module
  end
end
