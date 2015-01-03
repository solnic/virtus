require 'spec_helper'

describe Virtus::Attribute, '.coerce' do
  subject { described_class.coerce }

  after :all do
    described_class.coerce(true)
  end

  context 'with a value' do
    it 'sets the value and return self' do
      expect(described_class.coerce(false)).to be(described_class)
      expect(subject).to be(false)
    end
  end

  context 'when it is set to true' do
    before do
      described_class.coerce(true)
    end

    it { is_expected.to be(true) }
  end

  context 'when it is set to false' do
    before do
      described_class.coerce(false)
    end

    it { is_expected.to be(false) }
  end
end
