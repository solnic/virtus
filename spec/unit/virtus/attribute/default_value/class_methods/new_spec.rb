require 'spec_helper'

describe Virtus::Attribute::DefaultValue, '.new' do
  subject { described_class.new(value) }

  context 'with a cloneable value' do
    let(:value) { 'something' }

    its(:value) { should equal(value) }
  end

  context 'with a non-cloneable value' do
    [ nil, true, false, 1, :symbol ].each do |value|
      context "with #{value.inspect}" do
        let(:value) { value }

        its(:value) { should equal(value) }
      end
    end
  end
end
