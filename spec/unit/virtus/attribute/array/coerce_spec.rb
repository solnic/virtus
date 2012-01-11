require 'spec_helper'

describe Virtus::Attribute::Array, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute) { described_class.new(:colors) }

  context 'with a Hash' do
    let(:value) { { :foo => 'bar' } }

    it { should eql([ [ :foo, 'bar' ] ]) }
  end
end
