require 'spec_helper'

describe Virtus::Attribute::Collection, 'custom subclass' do
  subject { attribute_class.build(Array) }

  context 'when primitive is set on the attribute subclass' do
    let(:attribute_class) { Class.new(described_class) { primitive Array } }

    its(:primitive) { should be(Array) }
  end

  context 'when primitive is not set on the attribute subclass' do
    let(:attribute_class) { Class.new(described_class) }

    its(:primitive) { should be(Array) }
  end
end
