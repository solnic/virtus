require 'spec_helper'

describe Virtus::Attribute, '.coerce' do
  subject { described_class.coerce }

  after :all do
    described_class.coerce(true)
  end

  context 'when it is set to true' do
    before do
      described_class.coerce(true)
    end

    it { should be(true) }
  end

  context 'when it is set to false' do
    before do
      described_class.coerce(false)
    end

    it { should be(false) }
  end
end
