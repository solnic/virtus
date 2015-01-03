require 'spec_helper'

describe Virtus::Attribute::Boolean, '#value_coerced?' do
  subject { object.value_coerced?(input) }

  let(:object) { described_class.build('Boolean') }

  context 'when input is true' do
    let(:input) { true }

    it { is_expected.to be(true) }
  end

  context 'when input is false' do
    let(:input) { false }

    it { is_expected.to be(true) }
  end

  context 'when input is not coerced' do
    let(:input) { 1 }

    it { is_expected.to be(false) }
  end
end
