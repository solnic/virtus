require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '.coercer' do
  subject { described_class.coercer(type, options) }

  let(:options) { {} }

  context "when type is a virtus descendant" do
    let(:type) { Class.new { include Virtus } }

    it { should be_instance_of(described_class::OpenStructCoercer) }
  end

  context "when type is an OpenStruct descendant" do
    let(:type) { Class.new(OpenStruct) }

    it { should be_instance_of(described_class::OpenStructCoercer) }
  end

  context "when type is a Struct descendant" do
    let(:type) { Class.new(Struct.new(:foo)) }

    it { should be_instance_of(described_class::StructCoercer) }
  end

  context "when type is not an EV" do
    let(:type) { String }

    it { should be_instance_of(Virtus::Attribute::Coercer) }
  end
end
