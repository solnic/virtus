require 'spec_helper'

describe Virtus::ClassMethods, '.attribute' do
  subject { described_class.attribute(:name, type) }

  let(:described_class) do
    Class.new { include Virtus }
  end

  let(:virtus_class) do
    Class.new { include Virtus }
  end

  context 'with a string as type' do
    let(:type) { String }

    it { should be(described_class) }
  end

  context 'with a virtus class as type' do
    let(:type) { virtus_class }

    it { should be(described_class) }
  end
end
