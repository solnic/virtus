require 'spec_helper'

describe Virtus::Attribute, '#lazy?' do
  subject { object.lazy? }

  let(:object)  { described_class.build(String, options) }
  let(:options) { Hash[:lazy => lazy] }

  context 'when :lazy is set to true' do
    let(:lazy) { true }

    it { is_expected.to be(true) }
  end

  context 'when :lazy is set to false' do
    let(:lazy) { false }

    it { is_expected.to be(false) }
  end
end
