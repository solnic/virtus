require 'spec_helper'

describe Virtus::Attribute, '#value_coerced?' do
  subject { object.value_coerced?(value) }

  let(:object) { described_class::String.new(:name) }

  context 'when the value matches the primitive' do
    let(:value) { 'string' }

    it { should be(true) }
  end

  context 'when the value does not match the primitive' do
    let(:value) { 1 }

    it { should be(false) }
  end
end
