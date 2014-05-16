require 'spec_helper'

describe Virtus::Attribute, '#rename' do
  subject { object.rename(:bar) }

  let(:object) { described_class.build(String, :name => :foo, :strict => true) }
  let(:other)  { described_class.build(String, :name => :bar, :strict => true) }

  describe '#name' do
    subject { super().name }
    it { should be(:bar) }
  end

  it { should_not be(object) }
  it { should be_strict }
end
