require 'spec_helper'

describe Virtus::Attribute, '#allow_nil?' do
  subject { object.allow_nil? }

  let(:object) { described_class.build(String, :allow_nil => allow_nil) }

  context 'when allow_nil option is true' do
    let(:allow_nil) { true }

    it { should be(true) }
  end

  context 'when allow_nil option is false' do
    let(:allow_nil) { false }

    it { should be(false) }
  end
end
