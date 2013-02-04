require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '.determine_type' do
  subject { described_class.determine_type(value) }

  context "with Struct" do
    let(:value) { Struct.new(:x) }

    it { should be(described_class) }
  end

  context "with OpenStruct" do
    let(:value) { OpenStruct }

    it { should be(described_class) }
  end

  context "with a Virtus descendant" do
    let(:value) { Class.new { include Virtus; self } }

    it { should be(described_class) }
  end
end
