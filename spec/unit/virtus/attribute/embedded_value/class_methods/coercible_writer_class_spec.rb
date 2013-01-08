require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '.coercible_writer_class' do
  subject { described_class.coercible_writer_class(type, options) }

  let(:options) { {} }

  context "when type is a virtus descendant" do
    let(:type) { Class.new { include Virtus } }

    it { should be(described_class::OpenStructWriter) }
  end

  context "when type is an OpenStruct descendant" do
    let(:type) { Class.new(OpenStruct) }

    it { should be(described_class::OpenStructWriter) }
  end

  context "when type is a Struct descendant" do
    let(:type) { Class.new(Struct.new(:foo)) }

    it { should be(described_class::StructWriter) }
  end

  context "when type is not an EV" do
    let(:type) { String }

    it { should be(Virtus::Attribute::Writer::Coercible) }
  end
end
