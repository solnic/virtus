require 'spec_helper'

describe Virtus::Attribute::Set, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute) { described_class.new(:colors) }

  context 'with an Array' do
    let(:value) { [ :foo, 'bar', 'bar', :foo ] }

    it { should eql(Set[:foo, 'bar']) }
  end
end
