require 'spec_helper'

describe Virtus::AttributeSet, '#define_writer_method' do
  subject { described_class.new }

  let(:attribute) { Virtus::Attribute.build(String, :name => :foo_bar) }

  if RUBY_VERSION < '1.9'
    let(:method_name) { 'foo_bar=' }
  else
    let(:method_name) { :foo_bar= }
  end

  before do
    subject.define_reader_method(attribute, method_name, visibility)
  end

  context "with public visibility" do
    let(:visibility) { :public }

    its(:public_instance_methods) { should include(method_name) }
  end

  context "with private visibility" do
    let(:visibility) { :private }

    its(:private_instance_methods) { should include(method_name) }
  end

  context "with protected visibility" do
    let(:visibility) { :protected }

    its(:protected_instance_methods) { should include(method_name) }
  end
end
