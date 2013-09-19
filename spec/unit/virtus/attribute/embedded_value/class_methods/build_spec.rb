require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '.build' do
  subject { described_class.build(type) }

  context 'when type is a virtus model' do
    let(:type) { Class.new { include Virtus } }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue::FromOpenStruct) }
  end

  context 'when type is an OpenStruct subclass' do
    let(:type) { Class.new(OpenStruct) }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue::FromOpenStruct) }
  end

  context 'when type is OpenStruct' do
    let(:type) { OpenStruct }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue::FromOpenStruct) }
  end

  context 'when type is Struct' do
    let(:type) { Struct.new(:test) }

    it { should be_frozen }

    it { should be_instance_of(Virtus::Attribute::EmbeddedValue::FromStruct) }
  end
end
