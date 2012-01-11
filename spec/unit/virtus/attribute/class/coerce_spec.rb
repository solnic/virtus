require 'spec_helper'

describe Virtus::Attribute::Class, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute) { described_class.new(:type) }

  context 'with a String' do
    let(:value) { 'String' }

    it { should be(String) }
  end
end
