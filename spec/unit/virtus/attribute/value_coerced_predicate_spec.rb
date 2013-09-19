require 'spec_helper'

describe Virtus::Attribute, '#value_coerced?' do
  subject { object.value_coerced?(input) }

  let(:object) { described_class.build(String) }

  context 'when input is coerced' do
    let(:input)  { '1' }

    it { should be(true) }
  end

  context 'when input is not coerced' do
    let(:input)  { 1 }

    it { should be(false) }
  end
end
