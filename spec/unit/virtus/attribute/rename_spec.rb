require 'spec_helper'

describe Virtus::Attribute, '#rename' do
  subject { object.rename(:bar) }

  let(:object) { described_class.build(String, :name => :foo, :strict => true) }
  let(:other)  { described_class.build(String, :name => :bar, :strict => true) }

  describe '#name' do
    subject { super().name }
    it { is_expected.to be(:bar) }
  end

  it { is_expected.not_to be(object) }
  it { is_expected.to be_strict }
end
