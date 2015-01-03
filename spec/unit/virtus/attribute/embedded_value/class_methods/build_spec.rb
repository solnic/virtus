require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '.build' do
  subject { described_class.build(type) }

  context 'when type is a Virtus.model' do
    let(:type) { Class.new { include Virtus.model } }

    it { is_expected.to be_frozen }

    it { is_expected.to be_instance_of(Virtus::Attribute::EmbeddedValue) }

    describe '#coercer' do
      subject { super().coercer }
      it { is_expected.to be_instance_of(described_class::FromOpenStruct) }
    end
  end

  context 'when type includes Virtus' do
    let(:type) { Class.new { include Virtus } }

    it { is_expected.to be_frozen }

    it { is_expected.to be_instance_of(Virtus::Attribute::EmbeddedValue) }

    describe '#coercer' do
      subject { super().coercer }
      it { is_expected.to be_instance_of(described_class::FromOpenStruct) }
    end
  end

  context 'when type is an OpenStruct subclass' do
    let(:type) { Class.new(OpenStruct) }

    it { is_expected.to be_frozen }

    it { is_expected.to be_instance_of(Virtus::Attribute::EmbeddedValue) }

    describe '#coercer' do
      subject { super().coercer }
      it { is_expected.to be_instance_of(described_class::FromOpenStruct) }
    end
  end

  context 'when type is OpenStruct' do
    let(:type) { OpenStruct }

    it { is_expected.to be_frozen }

    it { is_expected.to be_instance_of(Virtus::Attribute::EmbeddedValue) }

    describe '#coercer' do
      subject { super().coercer }
      it { is_expected.to be_instance_of(described_class::FromOpenStruct) }
    end
  end

  context 'when type is Struct' do
    let(:type) { Struct.new(:test) }

    it { is_expected.to be_frozen }

    it { is_expected.to be_instance_of(Virtus::Attribute::EmbeddedValue) }

    describe '#coercer' do
      subject { super().coercer }
      it { is_expected.to be_instance_of(described_class::FromStruct) }
    end
  end
end
