require 'spec_helper'

describe Virtus::ClassMethods, '.attribute' do
  let(:described_class) do
    Class.new { include Virtus }
  end

  it 'returns self' do
    described_class.attribute(:name, String).should be(described_class)
  end
end
