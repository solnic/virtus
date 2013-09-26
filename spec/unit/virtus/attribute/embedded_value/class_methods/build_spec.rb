require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '.build' do
  subject { described_class.build(type) }

  context 'when type is a Virtus.model' do
    let(:type) { Class.new { include Virtus.model } }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue) }

    its(:coercer) { should be_instance_of(described_class::FromOpenStruct) }
  end

  context 'when type includes Virtus' do
    let(:type) { Class.new { include Virtus } }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue) }

    its(:coercer) { should be_instance_of(described_class::FromOpenStruct) }
  end

  context 'when type is an OpenStruct subclass' do
    let(:type) { Class.new(OpenStruct) }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue) }

    its(:coercer) { should be_instance_of(described_class::FromOpenStruct) }
  end

  context 'when type is OpenStruct' do
    let(:type) { OpenStruct }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue) }

    its(:coercer) { should be_instance_of(described_class::FromOpenStruct) }
  end

  context 'when type is Struct' do
    let(:type) { Struct.new(:test) }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue) }

    its(:coercer) { should be_instance_of(described_class::FromStruct) }
  end
end
