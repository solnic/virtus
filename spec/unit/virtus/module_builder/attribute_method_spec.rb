require 'spec_helper'

describe Virtus::ModuleBuilder, '.attribute_method' do
  subject { object.attribute_method(configuration) }

  let(:object)        { described_class.new(configuration) }
  let(:configuration) { Virtus::Configuration.build { |c| c.coerce = false } }
  let(:parent_class)  { Class.new }
  let(:child_class)   { Class.new(parent_class) }
  let(:options)       { {:coerce => false, :configured_coercer => configuration.coercer } }

  before do
    parent_class.should_receive(:attribute).with('attr_name', 'attr_type', options)
  end

  it 'calls super with the provided arguments and merged options' do
    child_class.send :define_singleton_method, :attribute, subject
    child_class.attribute('attr_name', 'attr_type')
  end
end
