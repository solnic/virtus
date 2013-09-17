require 'spec_helper'

describe Virtus::Attribute::Collection, 'custom subclass' do
  subject { attribute_class.build(primitive) }

  let(:primitive) { Class.new  { include Enumerable } }

  after do
    described_class.descendants.delete(attribute_class)
  end

  context 'when primitive is set on the attribute subclass' do
    let(:attribute_class) { Class.new(described_class).primitive(primitive) }

    its(:primitive) { should be(primitive) }
  end

  context 'when primitive is not set on the attribute subclass' do
    let(:attribute_class) { Class.new(described_class) }

    its(:primitive) { should be(primitive) }
  end
end
