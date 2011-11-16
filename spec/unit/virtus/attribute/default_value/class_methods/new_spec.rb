require 'spec_helper'

describe Virtus::Attribute::DefaultValue, '.new' do
  subject { described_class.new(attribute, value) }

  let(:attribute) { Virtus::Attribute::String.new(:attribute) }

  context 'with a duplicable value' do
    let(:value) { 'something' }
    its(:value) { should equal(value) }
  end

  context 'with a non-duplicable value' do
    [ nil, true, false, 1, :symbol ].each do |value|
      context "with #{value.inspect}" do
        let(:value) { value }
        its(:value) { should equal(value) }
      end
    end
  end
end
