require 'spec_helper'

describe Virtus::Attribute::Accessor::Builder, '#accessor_class' do
  subject { object.accessor_class }

  let(:object) { described_class.new('test', type, options) }
  let(:type)   { double('attribute_type').as_null_object }

  context "when :lazy is set to false" do
    let(:options) { { :lazy => false } }

    it { should be(Virtus::Attribute::Accessor) }
  end

  context "when :lazy is not set" do
    let(:options) { {} }

    it { should be(Virtus::Attribute::Accessor) }
  end

  context "when :lazy is set to true" do
    let(:options) { { :lazy => true } }

    it { should be(Virtus::Attribute::Accessor::LazyAccessor) }
  end
end
