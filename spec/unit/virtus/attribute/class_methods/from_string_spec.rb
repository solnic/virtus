require 'spec_helper'

describe Virtus::Attribute, '.from_string' do
  subject { object.from_string(string.to_s) }

  let(:object) { described_class }

  context 'when the string maps to an Attribute' do
    let(:string) { 'String' }

    it { should equal(Virtus::Attribute::String) }
  end

  context 'when the string does not map to an Attribute' do
    let(:string) { 'Unknown' }

    it { should be_nil }
  end
end
