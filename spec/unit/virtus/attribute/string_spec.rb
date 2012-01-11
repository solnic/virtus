require 'spec_helper'

describe Virtus::Attribute::String do
  describe '#coerce' do
    let(:attribute)      { described_class.new(:name) }
    let(:value)          { 1 }
    let(:coerce_value) { '1' }

    subject { attribute.coerce(value) }

    it { should eql(coerce_value) }
  end
end
