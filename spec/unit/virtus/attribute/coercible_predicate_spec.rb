require 'spec_helper'

describe Virtus::Attribute, '#coercible?' do
  subject { object.coercible? }

  let(:object)  { described_class.build(String, options) }
  let(:options) { Hash[:coerce => coerce] }

  context 'when :coerce is set to true' do
    let(:coerce) { true }

    it { is_expected.to be(true) }
  end

  context 'when :coerce is set to false' do
    let(:coerce) { false }

    it { is_expected.to be(false) }
  end
end
