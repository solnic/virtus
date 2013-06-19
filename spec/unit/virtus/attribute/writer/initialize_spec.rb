require 'spec_helper'

describe Virtus::Attribute::Writer, '#initialize' do
  subject { described_class.new(name, options) }

  let(:name) { 'test' }

  context "without options" do
    let(:options) { Hash.new }

    its(:name)                   { should be(:test=) }
    its(:visibility)             { should be(:public) }
    its(:instance_variable_name) { should be(:@test) }
    its(:options)                { should be_a(Hash) }
    its(:primitive)              { should be(Object) }
    its(:default_value)          { should be_instance_of(Virtus::Attribute::DefaultValue) }
  end

  context "with options specifying visibility, primitive and default" do
    let(:options) { { :visibility => :private, :primitive => String, :default => 'foo' } }

    its(:name)          { should be(:test=) }
    its(:visibility)    { should be(:private) }
    its(:options)       { should == options }
    its(:primitive)     { should be(String) }
    its(:default_value) { should be_instance_of(Virtus::Attribute::DefaultValue::FromClonable) }
  end
end
