require 'spec_helper'
require 'set'

describe Virtus::Attribute::Collection, '#value_coerced?' do
  subject { object.value_coerced?(input) }

  let(:object) { described_class.build(Array[Integer]) }

  context 'when input has correctly typed members' do
    let(:input) { [1, 2, 3] }

    it { is_expected.to be(true) }
  end

  context 'when input has incorrectly typed members' do
    let(:input) { [1, 2, '3'] }

    it { is_expected.to be(false) }
  end

  context 'when the collection type is incorrect' do
    let(:input) { Set[1, 2, 3] }

    it { is_expected.to be(false) }
  end

  context 'when the input is empty' do
    let(:input) { [] }
    it { is_expected.to be(true) }
  end
end
