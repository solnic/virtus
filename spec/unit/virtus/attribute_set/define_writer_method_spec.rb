require 'spec_helper'

describe Virtus::AttributeSet, '#define_writer_method' do
  subject(:attribute_set) { described_class.new }

  let(:attribute) { Virtus::Attribute.build(String, :name => method_name) }
  let(:method_name) { :foo_bar }

  before do
    attribute_set.define_writer_method(attribute, method_name, visibility)
  end

  context "with public visibility" do
    let(:visibility) { :public }

    it "defines public writer" do
      expect(attribute_set.public_instance_methods).to include(method_name)
    end
  end

  context "with private visibility" do
    let(:visibility) { :private }

    it "defines private writer" do
      expect(attribute_set.private_instance_methods).to include(method_name)
    end
  end

  context "with protected visibility" do
    let(:visibility) { :protected }

    it "defines protected writer" do
      expect(attribute_set.protected_instance_methods).to include(method_name)
    end
  end
end
