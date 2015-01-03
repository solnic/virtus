require 'spec_helper'

describe Virtus::Attribute::Collection, 'custom subclass' do
  subject { attribute_class.build(primitive) }

  let(:primitive) { Class.new  { include Enumerable } }

  after do
    described_class.descendants.delete(attribute_class)
  end

  context 'when primitive is set on the attribute subclass' do
    let(:attribute_class) { Class.new(described_class).primitive(primitive) }

    describe '#primitive' do
      subject { super().primitive }
      it { is_expected.to be(primitive) }
    end
  end

  context 'when primitive is not set on the attribute subclass' do
    let(:attribute_class) { Class.new(described_class) }

    describe '#primitive' do
      subject { super().primitive }
      it { is_expected.to be(primitive) }
    end
  end
end
