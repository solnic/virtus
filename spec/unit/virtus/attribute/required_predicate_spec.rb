require 'spec_helper'

describe Virtus::Attribute, '#required?' do
  subject { object.required? }

  let(:object) { described_class.build(String, :required => required) }

  context 'when required option is true' do
    let(:required) { true }

    it { is_expected.to be(true) }
  end

  context 'when required option is false' do
    let(:required) { false }

    it { is_expected.to be(false) }
  end
end
